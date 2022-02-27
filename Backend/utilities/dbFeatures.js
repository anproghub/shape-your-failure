class DBFeatures {

    constructor(dbQuery, queryObject) {
        this.dbQuery = dbQuery;
        this.queryObject = queryObject;
    }

    filter() {
        let queryObj = {...this.queryObject };

        // Removing the queries which cannot be applied to mongodb find object
        const excludedQueries = ['page', 'limit', 'sort', 'fields', 'searchFor', 'matchWith'];
        excludedQueries.forEach((query) => {
            delete queryObj[query];
        });

        // Handling queries with inequalities
        //
        // Eg - 
        // Object recieved will be { rating: { gt: 3.0 } }, and that accepted by mongoose will be { rating: { $gt: 3.0 }}
        let queryStr = JSON.stringify(queryObj);
        queryStr = queryStr.replace(/\bgt|gte|lt|lte\b/g, (match) => {
            return `$${match}`;
        });
        queryObj = JSON.parse(queryStr);

        this.dbQuery = this.dbQuery.find(queryObj);

        return this;
    }

    sort() {
        // Sorting the data
        if (this.queryObject.sort) {
            let sortBy = this.queryObject.sort.split(',').join(' ');
            this.dbQuery = this.dbQuery.sort(sortBy);
        } else {
            this.dbQuery = this.dbQuery.sort('-releasedAt');
        }

        return this;
    }

    filterFields() {
        // Selecting specific fields of data
        if (this.queryObject.fields) {
            let fields = this.queryObject.fields.split(',').join(' ');
            this.dbQuery = this.dbQuery.select(fields);
        } else {
            this.dbQuery = this.dbQuery.select('-__v');
        }

        return this;
    }

    paginate() {
        // Implementing pagination
        let page = this.queryObject.page * 1 || 1;
        let limit = this.queryObject.limit * 1 || 20;
        let skip = (page - 1) * limit;

        this.dbQuery = this.dbQuery.skip(skip).limit(limit);

        return this;
    }

    search() {

        if (this.queryObject.searchFor && this.queryObject.matchWith) {
            let field = this.queryObject.searchFor;
            let value = this.queryObject.matchWith;

            let obj = {};
            obj[field] = { $regex: new RegExp(value + '.*'), $options: 'i' };

            this.dbQuery = this.dbQuery.find(obj);
        }

        return this;
    }
}

module.exports = DBFeatures;
db.restaurants.find({}, { restaurant_id: 1, name: 1, borough: 1, cuisine: 1, _id: 0 })
//1
db.restaurants.find({ borough: "Bronx" }, { name: 1, borough: 1, _id: 0 }).sort({ name: 1 }).limit(5)
//2
db.restaurants.find({ "grades.score": { $gt: 80, $lt: 100 } }, { name: 1, _id: 0 })
//3
db.restaurants.find(
    {
        cuisine: { $ne: "American " },
        "grades.grade": "A",
        borough: { $ne: "Brooklyn" }
    },
    {
        name: 1, borough: 1, cuisine: 1, _id: 0
    }
).sort({ cuisine: 1 }).limit(2)
//4
db.restaurants.find(
    {
        name: /^Wil/
    },
    {
        name: 1, restaurant_id: 1, borough: 1, cuisine: 1, _id: 0
    }
).limit(3)
//5
db.restaurants.find(
    {
        $or:
            [
                { cuisine: "American " },
                { cuisine: "Chinese" }
            ],
        borough: "Bronx"
    },
    {
        cuisine: 1, name: 1, borough: 1, _id: 0
    }
)
//6
db.restaurants.find(
    {
        grades: {
            $elemMatch: {
                date: ISODate("2014-08-11T00:00:00Z"),
                score: 9,  // Без кавычек - это число!
                grade: "A"
            }
        }
    },
    {
        restaurant_id: 1,
        grades: 1,
        name: 1,
        _id: 0
    }
)
//7
db.restaurants.aggregate(
    [
        {
            $group: {
                _id: {
                    borough: "$borough",
                    cuisine: "$cuisine"
                },
                count: { $sum: 1 }
            }
        },
        {
            $project: {
                _id: 0,
                count: 1,
                borough: "$_id.borough",
                cuisine: "$_id.cuisine"
            }
        }
    ]
)
//8
db.restaurants.aggregate([
    { $match: { borough: "Bronx" } }, 
    { $unwind: "$grades" }, 
    {
        $group: {
            _id: {
                borough: "$borough",
                name: "$name",
                restaurant_id: "$restaurant_id"
            },
            total_score: { $sum: "$grades.score" },
        }
    },
    { $sort: { total_score: 1 } },
    { $limit: 1}

])
//9
db.restaurants.insertOne({
    name: "le mikalo",
    borough: "Brooklyn",
    cuisine: "French",
    restaurant_id: "10293847",
    grades: []
})
//10
db.restaurants.updateOne(
    {name: "le mikalo"},
    {
        $set: {
            work_hours: [
                {open: "08:00"},
                {close: "23:00"}
            ]
        }
    }
)
//11
db.restaurants.updateOne(
    {name: "le mikalo"},
    {
        $set: {
            work_hours: [
                {open: "10:00"},
                {close: "23:00"}
            ]
        }
    }
)
//12
db.restaurants.find(
    {name: "le mikalo"}
)
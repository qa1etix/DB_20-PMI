db.weather.aggregate(
    {$group: {
        _id: '$year',
        mintemp: {$min: '$temperature'},
        maxtemp: {$max: '$temperature'},
    }},
    {
        $project: {
            temp_difference: {$subtract: ['$maxtemp', '$mintemp']},
        }
    }
)
//1
db.weather.aggregate([
    {
        $facet: {
            min_temp_days: [
                {
                    $group: {
                        _id: {
                        month: "$month", 
                        day: "$day"
                        },
                        min_temp: {
                            $min: '$temperature'
                        }
                    },
                },
                {
                    $sort: {
                        min_temp: 1
                    }
                },
                {
                    $limit: 10
                },
            ],
            max_temp_days: [
                {
                    $group: {
                      _id: {
                        month: "$month",
                        day: "$day"
                      },
                      max_temp: {
                        $max: '$temperature'
                      }
                    }
                },
                {
                    $sort: {
                        max_temp: -1
                    }
                },
                {
                    $limit: 10
                },
            ],
        },
    },
    {
        $project: {
            excluded_days: {
                $concatArrays: [
                    '$min_temp_days._id',
                    '$max_temp_days._id',
                ]
            }
        }
    },
    {
        $lookup: {
          from: 'weather',
          let: {excluded: '$excluded_days'},
          pipeline: [
            {
                $match: {
                    $expr: {
                        $not: {
                            $in: [
                                {month: '$month', day: '$day'},
                                '$$excluded'
                            ]
                        }
                    }
                }
            },
            {
                $group: {
                    _id: null,
                    avg_temp: {
                        $avg: '$temperature'
                    }
                }
            }
          ],
          as: 'stats'
        }
    },
    {
        $project: {
            avg_result: {
                $arrayElemAt: ['$stats.avg_temp', 0]
            }
        }
    }
])
//2
db.weather.aggregate([
  {
    $facet: {
      south_wind_days: [
        {
          $match: {
            wind_direction: 'Южный'
          }
        },
        { $sort: { temperature: 1 } },
        { $limit: 10 },
        {
          $project: {
            temperature: 1,
            _id: 0 
          }
        }
      ]
    }
  },
  { $unwind: "$south_wind_days" }, 
  {
    $group: {
      _id: null,
      avg_temp: { $avg: "$south_wind_days.temperature" },
    }
  }
])
//3
db.weather.aggregate([
  {
    $match: {
      code: { $in: ['RA', 'SN'] }, 
      temperature: { $lt: 0 }      
    }
  },
  {
    $group: {
      _id: {
        year: '$year',
        month: '$month',
        day: '$day'
      }
    }
  },
  {
    $count: 'snow_days_count'
  }
])
//4
db.weather.aggregate(
    [
        {
            $facet: {
                snow: [
                    {
                        $match: {
                            month: {$in: [1,2,12]},
                            code : 'SN'
                        }
                    },
                    {
                        $count: 'count'
                    }
                ],
                rain: [
                    {
                        $match: {
                            month: {$in: [1,2,12]},
                            code : 'RA'
                        }
                    },
                    {
                        $count: 'count'
                    }
                ]
            }
        },
        {
            $project: {
                rainDaysCount: {$arrayElemAt: ['$snow', 0]},
                snowDaysCount: {$arrayElemAt: ['$rain', 0]},
            }
        },
        {
            $project: {
                difference: {$subtract: ['$rainDaysCount.count', '$snowDaysCount.count']}
            }
        }
    ]
)
//5
db.weather.aggregate([
  {
    $group: {
      _id: { year: '$year', month: '$month', day: '$day' },
      total: { $sum: 1 },
      clear: { $sum: { $cond: [{ $eq: ['$code', 'CL'] }, 1, 0] } },
      has_precip: { $max: { $cond: [
        { $in: ['$code', ['RA', 'SN', 'DZ', 'GR', 'SHRA', 'SNRA', 'SHSN', 'FZ', 'TS', 'HL']] },
        1,
        0
      ] } }
    }
  },
  { $match: { $expr: { $gte: [{ $divide: ['$clear', '$total'] }, 0.75] } } },
  {
    $group: {
      _id: null,
      clear_days: { $sum: 1 },
      precip_days: { $sum: '$has_precip' }
    }
  },
  {
    $project: {
      _id: 0,
      probability: {
        $cond: {
          if: { $eq: ['$clear_days', 0] },
          then: 0,
          else: { $divide: ['$precip_days', '$clear_days'] }
        }
      }
    }
  }
])
//6
db.weather.aggregate([
  {
    $group: {
      _id: null,
      total_avg: { $avg: '$temperature' },
      adjusted_records_ratio: {
        $avg: {
          $cond: {
            if: {
              $and: [
                { $in: ['$month', [12, 1, 2]] },
                { $eq: [{ $mod: ['$day', 2] }, 1] }
              ]
            },
            then: 1,
            else: 0
          }
        }
      }
    }
  },
  {
    $project: {
      _id: 0,
      temperature_change: { $round: ['$adjusted_records_ratio', 4] }
    }
  }
])
//7
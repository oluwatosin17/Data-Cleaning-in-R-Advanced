library(jsonlite)
world_cup_str  <-  '
[
    {
        "team_1": "France",
        "team_2": "Croatia",
        "game_type": "Final",
        "score" : [4, 2]
    },
    {
        "team_1": "Belgium",
        "team_2": "England",
        "game_type": "3rd/4th Playoff",
        "score" : [2, 0]
    }
    ]
'
world_cup_df <- fromJSON(world_cup_str)
print(world_cup_df)


hn <- fromJSON("hn_2014.json")
print(class(hn))

#Deleting variables from dataframe

first_story <- hn[1,]
str(first_story)

view(hn)

require("dotenv").config();

const Progress = require("../models/ProgressCard");
const Ranking = require("../models/RankingCard");

function buildPath(route)
{
    if (process.env.NODE_ENV === 'production')
    {
        return 'https://www.toptier.games/' + route;
    } else
    {
        return 'http://localhost:3001/' + route;
    }
}

const addUserGame = async (req, res) =>
{
    const newPCard = new Progress();
    newPCard.UserId = req.body.userId;
    newPCard.GameId = req.body.gameId;
    newPCard.HoursPlayed = 0.00;
    newPCard.DateLastPlayed = new Date();
    newPCard.DateAdded = new Date();
    newPCard.Status = 0;

    await newPCard.save();

    const newRCard = new Ranking();
    newRCard.UserId = req.body.userId;
    newRCard.GameId = req.body.gameId;

    await newRCard.save();

    return res.status(200).json({ id: 1, message: "User game added successfully." });
};

const getUserGame = async (req, res) =>
{
    let userId = req.body.userId;
    let pcard = await Progress.find({ UserId: userId });
    let rcard = await Ranking.find({ UserId: userId });

    let objects = [];


    if (pcard === null || rcard === null) 
    {
        return res.status(400).json({ games: [], message: "No games found." });
    }
    else
    {
        let len = pcard.length;

        for (let i = 0; i < len; i++)
        {
            let obj = {};

            obj.UserId = pcard[i].UserId;
            obj.GameId = pcard[i].GameId;
            obj.HoursPlayed = pcard[i].HoursPlayed;
            obj.Status = pcard[i].Status;
            obj.Ranking = rcard[i].Ranking;
            obj.Review = rcard[i].Review;

            objects.push(obj);
        }

        return res.status(200).json({ games: objects, message: "Games found." });
    }
};

const deleteUserGame = async (req, res) =>
{
    let userId = req.body.userId;
    let gameId = req.body.gameId;

    let pcard = await Progress.findOne({ UserId: userId, GameId: gameId });
    let rcard = await Progress.findOne({ UserId: userId, GameId: gameId });


    if (pcard === undefined || rcard === undefined) 
    {
        return res.status(400).json({ id: -1, message: "No games found." });
    }
    else
    {
        let presult = await Progress.deleteOne({ UserId: userId, GameId: gameId });
        let rresult = await Ranking.deleteOne({ UserId: userId, GameId: gameId });


        if (presult.deletedCount == 1 && rresult.deletedCount == 1)
        {
            return res.status(200).json({ id: 1, message: "User game deleted successfully." });

        }
        else
        {
            return res.status(400).json({ id: -1, message: "User game deleted unsuccessfully. Please try again." });
        }
    }
};
module.exports =
{
    addUserGame,
    getUserGame,
    deleteUserGame
};

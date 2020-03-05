const express = require('express');
const app = express();
const mysql = require('mysql2/promise');
const exphbs = require('express-handlebars');
const bodyParser = require('body-parser');
const path = require('path');


app.use(bodyParser.urlencoded({
    extended: false,
}));

// parse application/json
app.use(bodyParser.json());

app.set('views', path.join(__dirname, 'views'));

app.engine('handlebars', exphbs({
    defaultLayout: 'main',
    extname: '.handlebars',
    layoutsDir: path.join(__dirname, 'views', 'layouts'),
    partialsDir: path.join(__dirname, 'views', 'partials'),
}));

app.set('view engine', 'handlebars');

// create the connection to database
const connection = mysql.createPool({
    host: 'db',
    user: 'root',
    password: 'root',
    database: 'idp'
});


app.get('/', async (req, res) => {
    let schedules;
    try {
        [[schedules]] = await connection.execute(`CALL GetSchedulesFromNow();`);
    }
    catch (err) {
        res.sendStatus(500);
        return;
    }

    res.render('home', {
        active: {
            schedules: true,
        },
        schedules,
    });
});

app.get('/schedules/:id', async (req, res) => {
    let schedule, _, scheduleSeats;

    if (!req.params.id) {
        res.status(404).render('notfound');
        return;
    }

    try {
        [schedule, _] = await connection.execute(`CALL GetSchedule('${req.params.id}')`);

        [scheduleSeats, _] = await connection.execute(`CALL GetScheaduleSeats('${req.params.id}')`);

    }
    catch (err) {
        res.status(404).render('notfound');
        return;
    }
    if (schedule[0].length == 0 || scheduleSeats[0].length == 0) {
        res.status(404).render('notfound');
        return;
    }

    res.render('home', {
        active: {
            schedule: true,
        },
        schedule: schedule[0][0],
        scheduleSeats: JSON.stringify(scheduleSeats[0]),
        helpers: {
            convertTime(seconds) {
                let measuredTime = new Date(null);
                measuredTime.setSeconds(seconds); // specify value of SECONDS
                return measuredTime.toISOString().substr(11, 8);
            },
        },
    });
});

app.get('/admin', async (req, res) => {
    let movies, ecranisation, _;
    [movies, _] = await connection.execute(`CALL GetAllMovies();`);
    [ecranisation, _] = await connection.execute(`CALL GetEcranisationTypes()`);

    res.render('admin', {
        active: {
            insert: true,
        },
        ecranisation: ecranisation[0],
        movies: movies[0],
        helpers: {
            hello: () => {
                return 'dddd';
            },
        },
    });
});

app.get('/admin/schedule', async (req, res) => {

    let [movies, _] = await connection.execute(`CALL GetAllMovies();`);
    let [schedules, notUsed] = await connection.execute(`CALL GetSchedulesFromNow();`);
    let [rooms, notUsed2] = await connection.execute(`CALL GetRooms()`);

    let roomsIds = new Set(rooms[0].map(e => e.id));

    let processedRooms = [];
    for (let id of roomsIds) {
        let roo = rooms[0].filter(e => e.id == id);
        let roomToPush = {
            id,
            name: roo[0].name,
            capabilities: [],
            ecranisationName: [],
        };
        for (let room of roo) {
            roomToPush.capabilities.push(room.room_capabilities);
            roomToPush.ecranisationName.push(room.ecranisation_name);
        }

        roomToPush.ecranisationName = roomToPush.ecranisationName.join(', ');
        processedRooms.push(roomToPush);
    }


    res.render('admin', {
        active: {
            schedule: true,
        },
        movies: movies[0],
        schedules: schedules[0],
        rooms: processedRooms,
        helpers: {
            hello: () => {
                return 'dddd';
            },
        },
    });
});

app.get('/admin/raport', async (req, res) => {
    let schedules, _;
    try {
        [schedules, _] = await connection.execute(`CALL GetAllTimeSchedules()`);
    }
    catch (err) {
        console.log(err);
        res.sendStatus(500);
        return;
    }

    res.render('admin', {
        active: {
            raport: true,
        },
        schedules: schedules[0],
    });
});

app.post('/api/insertmovie', async (req, res) => {

    let movies, ecranisation, a, _;
    try {
        [movies, _] = await connection.execute(`CALL GetAllMovies();`);
        [ecranisation, a] = await connection.execute(`CALL GetEcranisationTypes()`);

    }
    catch (e) {
        res.sendStatus(502);
        return;
    }

    if (!req.body.name || !req.body.duration || !req.body.ecranisationType) {
        res.send({
            ok: false,
            reason: 'Not enoguh data',
        });
        return;
    }

    if (movies[0].filter(e => e.name == req.body.name && e.ecranisation_type == req.body.ecranisationType).length != 0) {
        console.log('Same movie');
        res.send({
            ok: false,
            reason: 'Movie allready exists',
        });
        return;
    }

    if (ecranisation[0].filter(e => e.id == req.body.ecranisationType).length == 0) {
        console.log('Ecranisation not exists');
        res.send({
            ok: false,
            reason: 'Ecranisation not exists',
        });
        return;
    }

    if (isNaN(parseInt(req.body.duration))) {
        console.log('Duration not a number');
        res.send({
            ok: false,
            reason: 'Duration not a number',
        });
        return;
    }

    try {
        let [response, u] = await connection.execute(`CALL InsertMovie('${req.body.name}', '${req.body.duration}', '${req.body.ecranisationType}')`);
    }
    catch (err) {
        res.sendStatus(500);
        return;
    }

    res.send({
        ok: true,
        reason: 'Inserted with success',
    });

});

app.post('/api/insertschedule', async (req, res) => {
    let data = req.body;

    if (!data.timestamp || !data.movie || !data.room) {
        res.send({
            ok: false,
            reason: 'Not enoguh data',
        });
        return;
    }
    let movies, schedules, rooms, _;

    try {
        [movies, _] = await connection.execute(`CALL GetAllMovies();`);
        [schedules, _] = await connection.execute(`CALL GetSchedulesFromNow();`);
        [rooms, _] = await connection.execute(`CALL GetRooms()`);
    }
    catch (err) {
        res.send({
            ok: false,
            reason: 'Server error',
        });
        return;
    }

    let roomsIds = new Set(rooms[0].map(e => e.id));
    let moviesOriginal = movies[0];
    movies = movies[0].filter(e => e.id == data.movie);

    let processedRooms = [];
    for (let id of roomsIds) {
        let roo = rooms[0].filter(e => e.id == id);
        let roomToPush = {
            id,
            name: roo[0].name,
            capabilities: [],
            ecranisationName: [],
        };
        for (let room of roo) {
            roomToPush.capabilities.push(room.room_capabilities);
            roomToPush.ecranisationName.push(room.ecranisation_name);
        }

        roomToPush.ecranisationName = roomToPush.ecranisationName.join(', ');
        processedRooms.push(roomToPush);
    }

    rooms = processedRooms.filter(e => e.id == data.room);

    if (!movies.length || !rooms.length) {
        res.send({
            ok: false,
            reason: 'Rooms ar movies are wrong',
        });
        return;
    }

    let movie = movies[0];
    let room = rooms[0];

    if (!room.capabilities.includes(movie.ecranisation_type)) {
        res.send({
            ok: false,
            reason: 'Capabilites not match',
        });
        return;
    }

    let date = new Date(data.timestamp);
    var userTimezoneOffset = date.getTimezoneOffset() * 60000;
    let wantedDate = new Date(date.getTime() - userTimezoneOffset);

    schedules = schedules[0].filter(e => e.room_id == room.id);
    if (schedules.length > 0) {

        for (let schedule of schedules) {

            let dt = new Date(schedule.timestamp);
            userTimezoneOffset = dt.getTimezoneOffset() * 60000;
            dt = new Date(dt.getTime() - userTimezoneOffset);

            let dt2 = new Date(schedule.timestamp);
            dt2.setSeconds(dt2.getSeconds() + moviesOriginal.filter(e => e.id = schedule.movie_id)[0].duration_seconds);
            dt2 = new Date(dt2.getTime() - userTimezoneOffset);

            if (dt.getTime() <= wantedDate.getTime() && dt2.getTime() >= wantedDate.getTime()) {
                res.send({
                    ok: false,
                    reason: 'Room is allready scheduled in that period',
                });
                return;
            }
        }
    }

    try {
        let [response, _] = await connection.execute(`CALL InsertSchedule('${wantedDate.toISOString().slice(0, 19).replace('T', ' ')}', '${data.movie}', '${data.room}')`);
        // if (movie.)
    }
    catch (err) {
        console.log(err);
        res.send({
            ok: false,
            reason: 'Server error',
        });
        return;
    }
    res.send({
        ok: true,
        reason: 'Inserted with success',
    });

});

app.post('/api/buytickets', async (req, res) => {
    let data = req.body;
    if (!data.scheduleID || !Array.isArray(data.toBuy)) {
        res.send({
            ok: false,
            reason: 'Data not valid',
        });
        return;
    }

    try {
        for (let ticket of data.toBuy) {
            let [response, _] = await connection.execute(`CALL BuyTickets('${data.scheduleID}', '${ticket}')`);
        }
    }
    catch (err) {
        console.log(err);
        res.send({
            ok: false,
            reason: 'Server error',
        });
        return;
    }
    res.send({
        ok: true,
        reason: 'Success',
    });
});

app.use((req, res) => {
    return res.status(404).render('notfound');
});

const port = 80;
app.listen(port, () => console.log(`Server listening on port ${port}!`));





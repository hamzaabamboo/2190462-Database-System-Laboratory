const express = require("express");
const app = express();
const port = 3000;
const mysql = require("mysql");
const bodyParser = require("body-parser");

app.set("view engine", "pug");

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "difficultpassword",
  database: "LAB7"
});

connection.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});

//app.get('/',(req,res) => res.send('hello world'));
app.get("/", (req, res) => {
  if (req.query.id != null) {
    connection.query(
      "SELECT * FROM Student WHERE student_id LIKE '%" + req.query.id + "%'",
      (err, result) => {
        res.render("index", {
          student: result
        });
      }
    );
    console.log("Search!");
  } else {
    connection.query("SELECT * FROM Student", (err, result) => {
      res.render("index", {
        student: result
      });
    });
    console.log("Query!");
  }
});

app.get("/add", (req, res) => {
  res.render("add");
});

app.post("/add", (req, res) => {
  const student_id = req.body.student_id;
  const name = req.body.name;
  const year = req.body.year;
  const email = req.body.email;
  const post = {
    student_id: student_id,
    name: name,
    year: year,
    email: email
  };
  connection.query("INSERT INTO Student SET ?", post, err => {
    console.log("Student Inserted");
    return res.redirect("/");
  });
});

app.get("/edit/:id", (req, res) => {
  const edit_postID = req.params.id;
  connection.query(
    "SELECT * FROM Student WHERE student_id=?",
    [edit_postID],
    (err, results) => {
      if (results) {
        res.render("edit", {
          student: results[0]
        });
      }
    }
  );
});

app.post("/edit/:id", (req, res) => {
  const update_name = req.body.name;
  const update_year = req.body.year;
  const update_email = req.body.email;
  const userId = req.params.id;
  connection.query(
    "UPDATE `Student` SET name = ?, year = ?, email = ? WHERE student_id = ?",
    [update_name, update_year, update_email, userId],
    (err, results) => {
      if (results.changedRows === 1) {
        console.log("Student Updated");
      }
      return res.redirect("/");
    }
  );
});

app.get("/delete/:id", (req, res) => {
  connection.query(
    "DELETE FROM `Student` WHERE student_id = ?",
    [req.params.id],
    (err, results) => {
      return res.redirect("/");
    }
  );
});

const takesRouter = new express.Router();

takesRouter.get("/");

takesRouter.get("/", (req, res) => {
  if (req.query.id != null) {
    connection.query(
      "SELECT *, Takes.year as cyear FROM Takes INNER JOIN Student ON Student.student_id = Takes.student_id INNER JOIN Course ON Course.cid = Takes.cid WHERE Takes.student_id LIKE '%" +
        req.query.id +
        "%'",
      (err, result) => {
        res.render("takes/index", {
          student: result
        });
      }
    );
    console.log("Search!");
  } else {
    connection.query(
      "SELECT *, Takes.year as cyear FROM Takes INNER JOIN Student ON Student.student_id = Takes.student_id INNER JOIN Course ON Course.cid = Takes.cid",
      (err, result) => {
        res.render("takes/index", {
          student: result
        });
      }
    );
    console.log("Query!");
  }
});

const promisifyQuery = (query, args) => {
  return new Promise((resolve, reject) => {
    connection.query(query, args, (err, res) => {
      if (err) {
        reject(err);
      }
      resolve(res);
    });
  });
};
takesRouter.get("/add", async (req, res) => {
  const students = await promisifyQuery("SELECT student_id, name FROM Student");
  const courses = await promisifyQuery("SELECT cid, title FROM Course");
  res.render("takes/add", {
    students,
    courses
  });
});

takesRouter.post("/add", (req, res) => {
  const { student_id, cid, sect_id, semester, year, grade } = req.body;
  const post = { student_id, cid, sect_id, semester, year, grade };
  connection.query("INSERT INTO Takes SET ?", post, err => {
    console.log("Student Inserted");
    return res.redirect("/takes");
  });
});

takesRouter.get(
  "/edit/:student_id/:cid/:sect_id/:semester/:year",
  async (req, res) => {
    const { student_id, cid, sect_id, semester, year } = req.params;
    const students = await promisifyQuery(
      "SELECT student_id, name FROM Student"
    );
    const courses = await promisifyQuery("SELECT cid, title FROM Course");

    connection.query(
      "SELECT * FROM Takes WHERE student_id=? AND cid=? AND sect_id=? AND semester=? AND year=?",
      [student_id, cid, sect_id, semester, year],
      (err, results) => {
        if (results) {
          console.log(results[0]);
          res.render("takes/edit", {
            students,
            courses,
            takes: results[0]
          });
        }
      }
    );
  }
);

takesRouter.post(
  "/edit/:student_id/:cid/:sect_id/:semester/:year",
  (req, res) => {
    const {
      student_id: rsid,
      cid: rcid,
      sect_id: rsecid,
      semester: rsem,
      year: ry
    } = req.params;
    const { student_id, cid, sect_id, semester, year, grade } = req.body;
    console.log(req.body, req.params);
    connection.query(
      `UPDATE Takes SET student_id = ?, cid=?, sect_id = ?, semester = ?, year = ?, grade = ? WHERE student_id=? AND cid=? AND sect_id=? AND semester=? AND year=?`,
      [
        student_id,
        cid,
        sect_id,
        semester,
        year,
        grade,
        rsid,
        rcid,
        rsecid,
        rsem,
        ry
      ],
      (err, results) => {
        console.log(results);
        if (results.changedRows === 1) {
          console.log("Enrollment Updated");
        }
        return res.redirect("/takes");
      }
    );
  }
);

takesRouter.get(
  "/delete/:student_id/:cid/:sect_id/:semester/:year",
  (req, res) => {
    const { student_id, cid, sect_id, semester, year } = req.params;
    connection.query(
      "DELETE FROM `Takes` WHERE student_id=? AND cid=? AND sect_id=? AND semester=? AND year=?",
      [student_id, cid, sect_id, semester, year],
      (err, results) => {
        return res.redirect("/takes");
      }
    );
  }
);

app.use("/takes/", takesRouter);

app.listen(port, () => console.log(`Example app listening on port ${port}!`));

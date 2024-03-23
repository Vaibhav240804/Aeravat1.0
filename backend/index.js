const express = require("express");
const { spawn } = require("child_process");
const bodyParser = require("body-parser");
const uR = require("./routers/userRouter.js");
const app = express();
const port = 3000;

const bR = express.Router();
app.use("/api", bR);
bR.use("/user", uR);

// Body parser middleware
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.post("/sms", (req, res) => {
  const smsText = req.body.sms_text;

  const pythonProcess = spawn("python", ["../SMS SPAM/SMS.py", smsText]);

  let prediction = "";

  pythonProcess.stdout.on("data", (data) => {
    prediction += data.toString();
  });

  pythonProcess.stderr.on("data", (data) => {
    console.error(`Error: ${data}`);
  });

  pythonProcess.on("close", (code) => {
    console.log(`Python script exited with code ${code}`);
    res.json({ prediction: prediction.trim() });
  });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

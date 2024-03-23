const express = require("express");
const { spawn } = require("child_process");
const bodyParser = require("body-parser");
const uR = require("./routers/userRouter.js");
const app = express();
const port = 3000;
const axios = require('axios');


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

app.get('/news', async (req, res) => {
  const options = {
      method: 'GET',
      url: 'https://reuters-business-and-financial-news.p.rapidapi.com/article-date/2024-01-01/0/20',
      headers: {
          'X-RapidAPI-Key': 'befc06d1b8msh6f066a8550ac960p15a686jsndc5ed0af9d9e',
          'X-RapidAPI-Host': 'reuters-business-and-financial-news.p.rapidapi.com'
      }
  };

  try {
      const response = await axios.request(options);
      res.json(response.data);
  } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'An error occurred while fetching data from Reuters API' });
  }
});


app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

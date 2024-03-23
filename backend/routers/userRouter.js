const express = require("express");
const auth = require("../middlewares/auth.js");
const UserController = require("../controllers/userController.js");

const uR = express.Router();

const uC = new UserController();

uR.post("/send-email", uC.sendEmail);
uR.post("/register", uC.register);
uR.post("/update", uC.update);
uR.post("/login", uC.login);
uR.post("/verify-otp", uC.verifyOtp);
uR.post("/get-user", uC.sendUserInfo);

module.exports = uR;

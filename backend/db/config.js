import mongoose from "mongoose";

const DB =
  "mongodb+srv://direct2vaibhavkore:OzcQP0oIIlM9XAFz@cluster0.suvqma4.mongodb.net/?retryWrites=true&w=majority";

function init() {
  if (!DB) console.log("DB not found in env");
  mongoose
    .connect(DB, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(() => {
      console.log(`DB connected`);
    })
    .catch((err) => console.log(`DB connection failed ${err}`));
}

export default init;

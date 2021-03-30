require('dotenv').config();


const required = ['DB_URL'];
const Config = required.reduce((acc, val) => {
  const value = process.env[val];
  if (!value) {
    throw `Config value: ${val} is required`;
  }
  acc[val] = value;
  return acc;
}, {});

module.exports = { Config };

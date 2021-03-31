db.createUser(
  {
    user: "test",
    pwd: "secret",
    roles : [
      {
        role: "readWrite",
        db: "mmiwg2s-submission-database"
      }
    ]
  }
)
package com.example;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class MongoTest {
    public static void main(String[] args) {
        // Read connection string from environment variable
        String connectionString = System.getenv("MONGODB_URI");
        if (connectionString == null || connectionString.isBlank()) {
            throw new IllegalStateException("❌ MONGODB_URI environment variable is not set!");
        }

        try (MongoClient mongoClient = MongoClients.create(connectionString)) {
            MongoDatabase db = mongoClient.getDatabase("admin");

            // Ping to confirm the connection really works
            db.runCommand(new Document("ping", 1));

            System.out.println("✅ Successfully connected to MongoDB Atlas!");
            System.out.println("Database name: " + db.getName());
        } catch (Exception e) {
            System.err.println("❌ Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
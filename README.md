# MongoDB Atlas Connection Test (Java 11)

A minimal Java project to verify connectivity to a MongoDB Atlas cluster using the official MongoDB Java Driver.

## Requirements
- Java 11 (or Docker)
- Maven 3.9+ (or Docker)
- A MongoDB Atlas cluster + connection string

## MongoDB Atlas Setup (Required!)

**IMPORTANT:** Before running this application, you MUST whitelist your IP address in MongoDB Atlas. MongoDB Atlas blocks all connections by default unless explicitly allowed.

1. Go to your [MongoDB Atlas dashboard](https://cloud.mongodb.com/)
2. Navigate to **Network Access** (under Security)
3. Click **Add IP Address**
4. Enter your public IP (find it by running: `curl -s ifconfig.me`) or use `0.0.0.0/0` for all IPs (less secure for production)
5. Save the changes

Skip this step and the connection will timeout with SSL errors.

## Usage

### Running Locally

1. Clone the repository and navigate to the project directory
2. Set your MongoDB Atlas connection string as an environment variable:
   ```bash
   export MONGODB_URI="mongodb+srv://username:password@cluster.mongodb.net/"
   ```
3. Build and run with Maven:
   ```bash
   mvn clean compile exec:java
   ```

### Running with Docker

1. **Build the Docker image:**
   ```bash
   docker build -t mongo-connection-test .
   ```

2. **Run the container:**
   ```bash
   docker run --rm -e MONGODB_URI="mongodb+srv://username:password@cluster.mongodb.net/" mongo-connection-test
   ```

   Replace `mongodb+srv://username:password@cluster.mongodb.net/` with your actual MongoDB Atlas connection string.

3. **Expected Output** (successful connection):
   ```
   ✅ Successfully connected to MongoDB Atlas!
   Database name: {database name}
   ```

### Troubleshooting

- **Timeout Errors**: Verify your internet connection and MongoDB Atlas credentials/IP allowlist
- **Permission Denied**: Check that the MongoDB user has read/write access to the cluster

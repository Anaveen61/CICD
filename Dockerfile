# Use a minimal Node.js base image
FROM node:14-alpine

# Create and set the working directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Expose the port that your app listens on
EXPOSE 3000

# Define how to run the application
CMD ["npm", "start"]

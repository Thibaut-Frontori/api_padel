import express from "express";
import cors from "cors";
import { ApolloServer } from "@apollo/server";
import { expressMiddleware } from "@apollo/server/express4";
import { gql } from "graphql-tag";
// Définition des types GraphQL
const typeDefs = gql `
  type Query {
    hello: String
  }
`;
// Définition des résolveurs
const resolvers = {
    Query: {
        hello: () => "Hello, world!",
    },
};
// Création du serveur Apollo
const server = new ApolloServer({
    typeDefs,
    resolvers,
});
// Fonction pour démarrer le serveur
async function startServer() {
    const app = express();
    // Middleware pour gérer CORS et JSON
    app.use(cors());
    app.use(express.json());
    // Démarrer Apollo avant de l'attacher à Express
    await server.start();
    // Intégration d'Apollo en tant que middleware
    app.use('/', cors(), express.json(), 
    // expressMiddleware accepts the same arguments:
    // an Apollo Server instance and optional configuration options
    expressMiddleware(server, {
        context: async ({ req }) => ({ token: req.headers.token }),
    }));
    // Démarrer le serveur Express
    app.listen(4000, () => {
        console.log("🚀 Server ready at http://localhost:4000/graphql");
    });
}
// Lancer le serveur
startServer();

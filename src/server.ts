import express from "express";
import cors from "cors";
import { ApolloServer } from "@apollo/server";
import { expressMiddleware } from "@apollo/server/express4";
import {typeDefs} from './graphql/shemas/typeDef.js'; 

const port = process.env.PORT || 4001;


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
  app.use(
    '/',
    cors<cors.CorsRequest>(),
    express.json(),
    // expressMiddleware accepts the same arguments:
    // an Apollo Server instance and optional configuration options
    expressMiddleware(server , {
      context: async ({ req }) => ({ token: req.headers.token }),
    }),
  );

  // Démarrer le serveur Express
  app.listen(port, () => {
    console.log(`🚀 Server ready at http://localhost:${port}/graphql`);
  });
}

// Lancer le serveur
startServer();

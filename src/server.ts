// npm install @apollo/server graphql
import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import { gql } from "graphql-tag";

// Définition des types GraphQL
const typeDefs = gql`
  type Query {
    hello: String
  }
`;

// Résolveurs associés aux types
const resolvers = {
  Query: {
    hello: () => "Hello, world!",
  },
};

// Création du serveur Apollo avec TypeScript
const server = new ApolloServer({
  typeDefs,
  resolvers,
});

// Lancement du serveur Apollo en mode standalone
const { url } = await startStandaloneServer(server, {
  context: async ({ req }) => ({
    token: req.headers.authorization || null, // Récupère le token d'authentification
  }),
  listen: { port: 4000 },
});

console.log(`🚀 Server ready at ${url}`);

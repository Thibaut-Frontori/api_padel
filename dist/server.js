"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const server_1 = require("@apollo/server");
const express4_1 = require("@apollo/server/express4");
const express_1 = __importDefault(require("express"));
const http_1 = __importDefault(require("http"));
const cors_1 = __importDefault(require("cors"));
require("dotenv/config");
// Création d'Express
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Création du serveur Apollo
const server = new server_1.ApolloServer({
    typeDefs: `#graphql
    type Query {
      hello: String
    }
  `,
    resolvers: {
        Query: {
            hello: () => "🚀 Apollo Server fonctionne !"
        }
    }
});
// Démarrer Apollo et l'intégrer à Express
await server.start();
app.use("/graphql", (0, express4_1.expressMiddleware)(server));
// Création du serveur HTTP
const httpServer = http_1.default.createServer(app);
const PORT = process.env.PORT || 4000;
httpServer.listen(PORT, () => {
    console.log(`🚀 Apollo Server prêt sur http://localhost:${PORT}/graphql`);
});

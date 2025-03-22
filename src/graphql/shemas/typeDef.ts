import fs from 'fs';
import path from 'path';
import { gql } from 'graphql-tag';
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const loadSchema = (file: string) =>
  fs.readFileSync(path.join(__dirname, file), 'utf-8');

export const typeDefs = gql`
  ${loadSchema('user.graphql')}
  ${loadSchema('court.graphql')}
  ${loadSchema('payment.graphql')}
  ${loadSchema('reservation.graphql')}
  ${loadSchema('review.graphql')}
  ${loadSchema('weather.graphql')}
  ${loadSchema('club.graphql')}
  ${loadSchema('location.graphql')}
`;



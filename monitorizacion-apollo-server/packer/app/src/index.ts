import apm from './apm';
import { ApolloServer, gql } from 'apollo-server';
import fs from 'fs';

const logPath = '/opt/apollo/logs/app.log';

const typeDefs = gql`
  type Book {
    title: String
    author: String
    publishedYear: Int
    genre: String
    pages: Int
    rating: Float
  }

  type Query {
    books: [Book]
  }
`;

const books = [
  {
    title: 'The Awakening',
    author: 'Kate Chopin',
    publishedYear: 1899,
    genre: 'Fiction',
    pages: 324,
    rating: 4.1
  },
  {
    title: 'City of Glass',
    author: 'Paul Auster',
    publishedYear: 1985,
    genre: 'Mystery',
    pages: 203,
    rating: 4.3
  },
  {
    title: '1984',
    author: 'George Orwell',
    publishedYear: 1949,
    genre: 'Dystopian',
    pages: 328,
    rating: 4.7
  },
  {
    title: 'To Kill a Mockingbird',
    author: 'Harper Lee',
    publishedYear: 1960,
    genre: 'Fiction',
    pages: 281,
    rating: 4.8
  },
  {
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    publishedYear: 1813,
    genre: 'Romance',
    pages: 279,
    rating: 4.6
  },
  {
    title: 'The Great Gatsby',
    author: 'F. Scott Fitzgerald',
    publishedYear: 1925,
    genre: 'Tragedy',
    pages: 180,
    rating: 4.4
  },
  {
    title: 'Moby-Dick',
    author: 'Herman Melville',
    publishedYear: 1851,
    genre: 'Adventure',
    pages: 635,
    rating: 4.0
  },
  {
    title: 'War and Peace',
    author: 'Leo Tolstoy',
    publishedYear: 1869,
    genre: 'Historical',
    pages: 1225,
    rating: 4.5
  }
];

const resolvers = {
  Query: {
    books: () => {
      const transaction = apm.startTransaction('Query - books', 'graphql');
      const span = apm.startSpan('Fetching books data');

      // Aquí va tu lógica
      const result = books;

      if (span) span.end();
      if (transaction) transaction.end();

      return result;
    },
  },
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
  context: ({ req }) => {
    try {
      const timestamp = new Date().toISOString();
      const query = (req.body?.query || 'Consulta sin query').replace(/\s+/g, ' ').trim();
      const ip = req.headers['x-forwarded-for'] || req.socket?.remoteAddress || 'IP desconocida';
      const method = req.method || 'Método desconocido';

      const logEntry = `Consulta ejecutada: ${timestamp} | IP: ${ip} | Método: ${method} | Query: ${query.slice(0, 300)}\n`;
      fs.appendFileSync(logPath, logEntry);
    } catch (err) {
      const errorMsg = err instanceof Error ? err.message : JSON.stringify(err);
      fs.appendFileSync(
        logPath,
        `Error al registrar consulta: ${new Date().toISOString()} | ${errorMsg}\n`
      );
    }

    return {};
  }
});

server.listen().then((res: any) => {
  console.log(`Server ready at ${res.url}`);
});

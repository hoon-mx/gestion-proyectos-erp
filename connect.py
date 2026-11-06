#!/usr/bin/env python3
import logging
import os

import pydgraph
from cassandra.cluster import Cluster
from pymongo import MongoClient

# Set logger
log = logging.getLogger()
log.setLevel('INFO')
handler = logging.FileHandler('gestion_proyectos.log')
handler.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s] %(name)s: %(message)s"))
log.addHandler(handler)

# Read env vars related to each database
MONGO_URI = os.getenv('MONGO_URI', 'mongodb://localhost:27017/')
MONGO_DB = os.getenv('MONGO_DB', 'gestion_proyectos')

CLUSTER_IPS = os.getenv('CASSANDRA_CLUSTER_IPS', '127.0.0.1')
KEYSPACE = os.getenv('CASSANDRA_KEYSPACE', 'gestion_proyectos')
REPLICATION_FACTOR = os.getenv('CASSANDRA_REPLICATION_FACTOR', '1')

DGRAPH_URI = os.getenv('DGRAPH_URI', 'localhost:9080')

CREATE_KEYSPACE = """
        CREATE KEYSPACE IF NOT EXISTS {}
        WITH replication = {{ 'class': 'SimpleStrategy', 'replication_factor': {} }}
"""


def connect_mongo():
    log.info(f"Connecting to MongoDB at {MONGO_URI}")
    client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=5000)
    client.admin.command('ping')
    return client[MONGO_DB]


def connect_cassandra():
    log.info(f"Connecting to Cassandra cluster {CLUSTER_IPS}")
    cluster = Cluster(CLUSTER_IPS.split(','))
    session = cluster.connect()
    session.execute(CREATE_KEYSPACE.format(KEYSPACE, REPLICATION_FACTOR))
    session.set_keyspace(KEYSPACE)
    return session


def connect_dgraph():
    log.info(f"Connecting to Dgraph at {DGRAPH_URI}")
    client_stub = pydgraph.DgraphClientStub(DGRAPH_URI)
    client = pydgraph.DgraphClient(client_stub)
    client.check_version()
    return client


if __name__ == '__main__':
    db = connect_mongo()
    print(f"MongoDB conectado, base: {db.name}")

    session = connect_cassandra()
    print(f"Cassandra conectado, keyspace: {session.keyspace}")

    client = connect_dgraph()
    print(f"Dgraph conectado, versión: {client.check_version()}")

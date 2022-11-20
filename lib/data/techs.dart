import 'package:flutter/material.dart';
import '/models/tech.dart';

List<Tech> Techs = [
  Tech(
    desc:
        'The Graph is an indexing protocol for querying networks like Ethereum and IPFS. Anyone can build and publish open APIs, called subgraphs, making data easily accessible.',
    title: 'The Graph',
    logo: Image.asset('assets/stack/graph.png'),
  ),
  Tech(
    desc:
        'Interplanneetary file system used for storage. It is a peer-to-peer hypermedia protocol designed to preserve and grow humanitys knowledge by making the web upgradeable, resilient, and more open.',
    title: 'IPFS',
    logo: Image.asset('assets/stack/ipfs.png'),
  ),
  Tech(
    desc:
        'Blockchain based technology used for accounting. It is the community-run technology powering the cryptocurrency ether (ETH) and thousands of decentralized applications.',
    title: 'Ethereum',
    logo: Image.asset('assets/stack/eth.png'),
  ),
  Tech(
    desc:
        'Accelerate development, address diverse data sets, and adapt quickly to change with a proven application data platform built around the database most wanted by developers 4 years running',
    title: 'MongoDB',
    logo: Image.asset('assets/stack/mongo.png'),
  ),
  Tech(
    desc:
        'IPLD is the data model of the content-addressable web. It allows us to treat all hash-linked data structures as subsets of a unified information space, unifying all data models that link data with hashes as instances of IPLD.',
    title: 'IPLD',
    logo: Image.asset('assets/stack/ipld.png'),
  ),
];

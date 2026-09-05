# Knowledge Engineering Project: Fraud Detection for Credit Card Transactions

This repository contains the full implementation of a fraud detection system developed as part of the university project in Knowledge Engineering.

The project explores multiple paradigms : decision tables, logic programming, ontology engineering, and semantic querying. The goal was to design a smart system capable of evaluating financial transactions and identifying suspicious patterns based on geographic, economic, and behavioral risk indicators.

## Overview

The goal of the project was to develop a system capable of classifying credit card transactions as accepted, blocked, or rejected according to a set of risk factors. The project was approached across three main modeling layers:

1. Rule-based logic using a **DMN** decision table
2. Declarative reasoning using **Prolog**
3. Semantic representation and querying using **OWL ontologies** and **SPARQL**

The core risk dimensions considered include:

- country of the cardholder;
- country of the merchant;
- transaction amount;
- transaction type (online or physical);
- special risk conditions;
- temporal comparison between transactions.

## Technologies

* **DMN (Decision Model and Notation)** via **Trisotech**
* **Prolog** (**SWI-Prolog**)
* **Ontology** using **Protégé**
* **OWL** for semantic domain modeling
* **SPARQL** for querying the knowledge base
* **RDF/XML** and **Turtle (TTL)** for ontology serialization

## Architecture

The system evolves through increasing expressiveness:

* From decision tables for rule encoding and business logic
* To logic programming for transaction risk scoring and classification
* To ontology-based modeling for semantic representation of the domain
* To semantic queries for retrieving and validating risk-related knowledge


## Repository Structure

```text
KE-project/
├── Decision tables/
│   └── Fraud detection final.dmn
├── Ontology/
│   ├── ontology-graph-class_rel.png
│   └── ontology-creditcard.owl
├── Prolog/
│   └── Fraud_detection.pl
├── Protege/
│   ├── Fraud_detection.ttl
│   └── Query.txt
├── Report/
│   ├── ProjectDescription.pdf
│   └── Report.pdf   
├── README.md
└── .git/
```

## Authors

This project was developed by:

- Nicola Lerco
- Riccardo Peruzzi

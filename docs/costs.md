# Estimation des coûts

> Ordres de grandeur à vérifier avec l'**AWS Pricing Calculator** pour la région `eu-north-1` (les tarifs changent). Les montants sont indicatifs.

## Ressources susceptibles de générer des coûts (environnement dev)

| Ressource | Quantité | Facturation | Ordre de grandeur |
|---|---|---|---|
| NAT Gateway | 1 | horaire + Go traités | ≈ 0,045 $/h |
| Application Load Balancer | 1 | horaire + LCU | ≈ 0,02 $/h |
| EC2 t3.micro | 2 | horaire | ≈ 0,01 $/h chacune |
| RDS db.t3.micro (mono-AZ) + 20 Go gp3 | 1 | horaire + stockage | ≈ 0,02 $/h |
| Adresses IPv4 publiques (EIP NAT, ALB) | ≈ 3 | horaire | ≈ 0,005 $/h chacune |
| Secrets Manager (mot de passe RDS) | 1 | par secret/mois | quelques centimes |
| S3 (état, assets) | 2 buckets | stockage + requêtes | négligeable |
| EBS gp3 8 Go | 2 | Go/mois | négligeable |

**Total dev allumé : ≈ 0,12 à 0,15 $/h, soit ≈ 3 $/jour.**

## Prod (non déployée pour la démonstration)

Un NAT par AZ et un RDS Multi-AZ environ doublent le coût horaire du réseau et de la base.

## Maîtrise des coûts

- Un seul NAT en dev/test (`single_nat_gateway = true`), instances `t3.micro`, RDS mono-AZ.
- Budget AWS avec alerte e-mail configuré.
- `terraform destroy` dès la démonstration terminée ; vérification dans la console qu'il ne reste ni NAT Gateway, ni ALB, ni RDS, ni Elastic IP.
- `test` et `prod` ne sont jamais déployés automatiquement.
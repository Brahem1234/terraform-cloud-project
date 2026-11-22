# Choix de sécurité

## Réseau et pare-feu

| Contrôle | Mise en œuvre |
|---|---|
| Instances et base non exposées | Instances dans des sous-réseaux privés App, RDS dans des sous-réseaux privés DB (aucune route vers Internet) |
| Chaînage des Security Groups | ALB : 80/443 depuis Internet. App : 80 **uniquement depuis le SG de l'ALB**. DB : 3306 **uniquement depuis le SG App** |
| Sortie contrôlée | Les instances privées sortent via NAT Gateway, sans adresse publique |
| RDS inaccessible depuis Internet | `publicly_accessible = false`, SG fermé, test de connexion depuis Internet refusé |

## Identités et accès

| Contrôle | Mise en œuvre |
|---|---|
| Moindre privilège EC2 | Rôle limité à `AmazonSSMManagedInstanceCore` et à `s3:GetObject/PutObject` sur `logs/*` du bucket du projet |
| Accès administratif | Via **SSM Session Manager**, aucun port SSH ouvert, aucune clé `.pem` |
| Pipeline sans clé | Fédération **OIDC GitHub → AWS** : pas de clé d'accès longue durée |
| Séparation plan / apply | Rôle `plan` en lecture seule (+ accès à l'état), rôle `apply` utilisable uniquement depuis les environnements GitHub protégés |
| Approbation | `test` et `prod` exigent un réviseur, et ne se déploient que depuis `main` |

## Secrets

- Aucun mot de passe ni clé dans Git (le dépôt ne contient ni `tfstate`, ni `.terraform`, ni `.pem`).
- Mot de passe RDS généré et stocké dans **AWS Secrets Manager** (`manage_master_user_password = true`).
- Variables sensibles absentes de `terraform.tfvars` ; un `terraform.tfvars.example` sans secret est fourni.

## Données et chiffrement

| Ressource | Protection |
|---|---|
| État Terraform (S3) | Chiffrement AES256, versioning, accès public bloqué, refus du trafic non TLS, verrouillage `use_lockfile`, états séparés par environnement |
| Bucket applicatif | Chiffrement, versioning, accès public bloqué, règles de cycle de vie |
| RDS | `storage_encrypted = true` |
| Volumes EBS | Chiffrés |
| Instances | IMDSv2 obligatoire (`http_tokens = required`) |

## Limites connues et améliorations

- Le rôle `apply` est large (PowerUserAccess + IAM restreint au préfixe `cloud5-`) : à resserrer avec IAM Access Analyzer.
- HTTPS non activé faute de domaine : prévoir un certificat ACM et un listener 443 avec redirection.
- Pas de WAF, pas de journalisation ALB : améliorations possibles.
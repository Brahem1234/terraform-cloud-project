### Test de panne
- Procédure : arrêt de l'instance i-XXXX (AZ eu-north-1a) avec `aws ec2 stop-instances` à HH:MM:SS.
- Observation : l'URL de l'ALB est restée accessible, les requêtes ont été servies par l'instance i-YYYY (eu-north-1b).
- Détection : la cible est passée Unhealthy après environ 30 s (2 health checks de 15 s).
- Remplacement : l'Auto Scaling Group a lancé une nouvelle instance, Healthy à HH:MM:SS (environ N minutes).
- Résultat : SUCCÈS. Continuité de service assurée, capacité restaurée automatiquement.
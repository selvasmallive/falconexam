# infra/terraform — Google Cloud infrastructure

**Not implemented yet.** Delivered in Milestone 6
(`development-kit/prompts/06-google-cloud-marketplace.md`).

Planned: isolated dev / test / UAT / prod environments; Cloud Run for stateless services; Cloud SQL
PostgreSQL; Memorystore Redis; Cloud Storage; Pub/Sub; Cloud Tasks; Secret Manager; Cloud KMS;
Cloud Armor; Artifact Registry; Cloud Monitoring. GKE only where GPU or specialized media
orchestration is justified.

Workload identity and least-privilege service accounts throughout. Backup/restore and disaster
recovery are tested, not assumed.

Never commit `*.tfvars` (except `example.tfvars`), state files or service-account keys.

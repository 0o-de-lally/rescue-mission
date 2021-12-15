
# Rescue missions

Something happend and we can't yet explain it. Restoring from the last epoch change doesn't help, since an upgrade or something messed it up.

But the spice must flow. So we will take a snapshot of a known-good block-height from one node, and share here.

![spice](the-spice-must-flow.png)

## Using a rescue snapshot
Rescue snapshots are saved by their block height e.g. `12212197` (upgrade rescue for epoch 51).

Restore an archive with:

```
HEIGHT=12212197 make the-spice-must-flow
```

## The actual restore commands

#### epoch
	db-restore --target-db-dir ~/.0L/db epoch-ending --epoch-ending-manifest ./area-51/epoch_ending*/epoch_ending.manifest local-fs --dir ${ARCHIVE_PATH}/${EPOCH}

#### transaction
  db-restore --target-db-dir ~/.0L/db transaction --transaction-manifest ./area-51/transaction_*/transaction.manifest local-fs --dir .
#### state

  db-restore --target-db-dir ~/.0L/db state-snapshot --state-manifest ./area-51/state_ver_*/state.manifest --state-into-version 12212197 local-fs --dir .


## Making a rescue snapshot

You'll need to create a restore point of
- The epoch boundary (as the epoch-archive already does)
- One transaction (block) at a good blockheight
- A State snapshot

####  epoch
	db-backup one-shot backup --backup-service-address ${URL}:6186 epoch-ending --start-epoch 51--end-epoch 51 local-fs --dir .

#### transaction
  db-backup one-shot backup --backup-service-address http://localhost:6186 transaction --num_transactions 1 --start-version 12212197 local-fs --dir .

#### state
  db-backup one-shot backup --backup-service-address http://localhost:6186 state-snapshot --state-version 12212197 local-fs --dir ~/test_backup

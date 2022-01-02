
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

These example commands assume that the state was stored to a path ./$HEIGHT/ which uses the same height as the snapshot.

#### epoch
	db-restore --target-db-dir ~/.0L/db epoch-ending --epoch-ending-manifest ./$HEIGHT/epoch_ending*/epoch_ending.manifest local-fs --dir ./$HEIGHT/

#### transaction
  db-restore --target-db-dir ~/.0L/db transaction --transaction-manifest ./$HEIGHT/transaction_*/transaction.manifest local-fs --dir ./$HEIGHT/
#### state

  db-restore --target-db-dir ~/.0L/db state-snapshot --state-manifest ./$HEIGHT/state_ver_*/state.manifest --state-into-version $HEIGHT local-fs --dir ./$HEIGHT/


## Making a rescue snapshot

You can save a snapshot point with:
```
HEIGHT=<the current height> EPOCH=<the current epoch> make save
```

You'll need to create a restore point of
- The epoch boundary (as the epoch-archive already does)
- One transaction (block) at a good blockheight
- A atate snapshot

####  epoch
	db-backup one-shot backup --backup-service-address ${URL}:6186 epoch-ending --start-epoch $EPOCH --end-epoch 51 local-fs --dir ./$HEIGHT/

#### transaction
  db-backup one-shot backup --backup-service-address http://localhost:6186 transaction --num_transactions 1 --start-version $HEIGHT local-fs --dir ./$HEIGHT/

#### state
  db-backup one-shot backup --backup-service-address http://localhost:6186 state-snapshot --state-version $HEIGHT local-fs --dir ./$HEIGHT/

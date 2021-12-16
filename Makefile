SHELL=/usr/bin/env bash

ifndef DATA_PATH
DATA_PATH=~/.0L
endif

ifndef DB_PATH
DB_PATH=${DATA_PATH}/db
endif

PREV_EPOCH= $$((${EPOCH}-1))

echo:
	echo ${PREV_EPOCH}

the-spice-must-flow:
	@echo EPOCH
	db-restore --target-db-dir ${DB_PATH} epoch-ending --epoch-ending-manifest ~/rescue-mission/${HEIGHT}/epoch_ending*/epoch_ending.manifest local-fs --dir ~/rescue-mission/${HEIGHT}
  
	@echo TRANSACTION

	db-restore --target-db-dir ${DB_PATH} transaction --transaction-manifest ~/rescue-mission/${HEIGHT}/transaction_*/transaction.manifest local-fs --dir ~/rescue-mission/${HEIGHT}

	@echo STATE
	db-restore --target-db-dir ${DB_PATH} state-snapshot --state-manifest ~/rescue-mission/${HEIGHT}/state_ver_*/state.manifest --state-into-version ${HEIGHT} local-fs --dir ~/rescue-mission/${HEIGHT}

save: save-epoch save-tx save-state

save-epoch:
	@echo EPOCH
	db-backup one-shot backup --backup-service-address http://localhost:6186 epoch-ending --start-epoch ${PREV_EPOCH} --end-epoch ${EPOCH} local-fs --dir ~/rescue-mission/${HEIGHT}

save-tx:
	@echo TRANSACTION
	db-backup one-shot backup --backup-service-address http://localhost:6186 transaction --num_transactions 1 --start-version ${HEIGHT} local-fs --dir ~/rescue-mission/${HEIGHT}

save-state:
	@echo STATE
	db-backup one-shot backup --backup-service-address http://localhost:6186 state-snapshot --state-version ${HEIGHT}  local-fs --dir ~/rescue-mission/${HEIGHT}

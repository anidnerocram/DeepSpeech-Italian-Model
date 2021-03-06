#!/bin/bash

set -xe

pushd $DS_DIR
	# USE DEV_FILES!!!
	# --test_files MUST USE DEV_FILES and not TEST!
	all_dev_csv="$(find /mnt/extracted/data/ -type f -name '*dev.csv' -printf '%p,' | sed -e 's/,$//g')"

	if [ -z "${LM_EVALUATE_RANGE}" ]; then
		echo "No language model evaluation range, skipping"
		exit 0
	fi;

	if [ ! -z "${LM_EVALUATE_RANGE}" ]; then
		LM_ALPHA_MAX="$(echo ${LM_EVALUATE_RANGE} |cut -d',' -f1)"
		LM_BETA_MAX="$(echo ${LM_EVALUATE_RANGE} |cut -d',' -f2)"
		LM_N_TRIALS="$(echo ${LM_EVALUATE_RANGE} |cut -d',' -f3)"
		python lm_optimizer.py \
			--alphabet_config_path /mnt/models/alphabet.txt \
			--scorer_path /mnt/lm/scorer \
			--test_files ${all_dev_csv} \
			--test_batch_size ${BATCH_SIZE} \
			--lm_alpha_max ${LM_ALPHA_MAX} \
			--lm_beta_max ${LM_BETA_MAX} \
			--n_trials ${LM_N_TRIALS} \
			--checkpoint_dir /mnt/checkpoints/
	fi;
popd

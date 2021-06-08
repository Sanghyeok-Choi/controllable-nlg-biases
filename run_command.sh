#!/bin/sh

#SBATCH --ntasks=1
#SBATCH --gres=gpu:2

sbatch -n 2 --gres=gpu:2 -c 32 run_sbatch \
# 'python -u src/create_adv_token.py --neg_sample_file data/gpt2_neg_regard.tsv --neu_sample_file data/gpt2_neu_regard.tsv --pos_sample_file data/gpt2_pos_regard.tsv --neg_name_file data/US_SS_name/male_name_file.txt --pos_name_file data/US_SS_name/female_name_file.txt'
# 'python -u src/create_adv_token.py --neg_sample_file data/gpt2_neg_regard.tsv --neu_sample_file data/gpt2_neu_regard.tsv --pos_sample_file data/gpt2_pos_regard.tsv --neg_name_file data/US_SS_name/female_name_file.txt --pos_name_file data/US_SS_name/male_name_file.txt'

# -u Force stdin, stdout and stderr to be totally unbuffered. On systems where it matters, also put stdin, stdout and stderr in binary mode.
# Note that there is internal buffering in xreadlines(), readlines() and file-object iterators ("for line in sys.stdin") which is not influenced by this option. To work around this, you will want to use "sys.stdin.readline()" inside a "while 1:" loop."

srun2 python src/eval_triggers.py --trigger_dump_file slurm_outputs/slurm-341329.out --trigger_label_output_dir "output" --regard_classifier_dir "" --neg_demographic "The man" --pos_demographic "The woman"

sbatch -n 2 --gres=gpu:2 run_sbatch 'python src/sample_from_gpt2.py \
--trigger_list "49479,17847,39989,43209,34656,38768" \
--trigger_label_output_dir "output_name" \
--neg_name_file data/US_SS_name/male_name_file.txt \
--pos_name_file data/US_SS_name/female_name_file.txt \
--model "gpt2"' \
'python src/sample_from_gpt2.py \
--trigger_list "9472,407,477,790,1123,3083" \
--trigger_label_output_dir "output_name" \
--neg_name_file data/US_SS_name/female_name_file.txt \
--pos_name_file data/US_SS_name/male_name_file.txt \
--model "gpt2"'




#!/usr/bin/env bash
pdfs=(
  'https://docs.aws.amazon.com/pdfs/wellarchitected/latest/framework/wellarchitected-framework.pdf'
  'https://d1.awsstatic.com/training-and-certification/docs-sysops-associate/AWS-Certified-SysOps-Administrator-Associate_Exam-Guide.pdf'
)

for pdf in "${pdfs[@]}"; do
  wget "$pdf"
done

"""
Test_1
"""

import filecmp
import subprocess


def test_1():
    """Test_1"""
    subprocess.run(["cwl-runner",
                    "./workflow/Retrieve_GC_workflow.cwl",
                    "./tests/test_file_ex1_5_3_gz.yml"])
    subprocess.run(["gzip", "-d", "-f", "./ex1_5_3_gz_test.wig.gz"])
    assert filecmp.cmp("./ex1_5_3_gz_test.wig", "./tests/ex1_5_3.wig")


if __name__ == "__main__":
    test_1()
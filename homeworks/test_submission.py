import os
import runpy

import matplotlib
matplotlib.use("Agg")   # draw plots off-screen so plt.show() doesn't pause the tests
import matplotlib.pyplot as plt
import pandas as pd
import pytest
pytestmark = pytest.mark.filterwarnings("ignore:FigureCanvasAgg is non-interactive")

SUBMISSION_NAME = "hw6.py"  # must match run_autograder below


@pytest.fixture(scope="module")
def submission():
    """Executes the student's submission and returns its top-level variables."""
    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, "..", SUBMISSION_NAME)
    os.chdir(os.path.dirname(os.path.abspath(path)))  # so iris.csv is found
    return runpy.run_path(path)


ALL_DOGS = {"Charlie", "Gus", "Stubby", "Toni", "Pearl", "Arya", "Shelby"}
DOGS_1 = {"Charlie", "Gus", "Stubby", "Toni", "Pearl"}
DOGS_2 = {"Charlie", "Gus", "Toni", "Arya", "Shelby"}
SPECIES_TO_SHORT = {"Iris-setosa": "s", "Iris-versicolor": "vers",
                    "Iris-virginica": "virg"}


# Question 3a ------------------------------------------------------------------
def test_3a_merged1_has_every_dog(submission):
    # Outer join: one row for each of the 7 dogs from either table
    assert "merged1" in submission
    m = submission["merged1"]
    assert set(m["dog"]) == ALL_DOGS
    assert len(m) == 7
    assert {"dog", "nickname", "breed"} <= set(m.columns)


# Question 3b ------------------------------------------------------------------
def test_3b_merged2_has_only_dataset1_dogs(submission):
    # Left join: exactly the 5 dogs in dataset1; Stubby and Pearl have no breed
    assert "merged2" in submission
    m = submission["merged2"]
    assert set(m["dog"]) == DOGS_1
    assert len(m) == 5
    assert m.loc[m["dog"] == "Pearl", "breed"].isna().all()


# Question 3c ------------------------------------------------------------------
def test_3c_merged3_has_only_dataset2_dogs(submission):
    # Right join: exactly the 5 dogs in dataset2; Arya and Shelby have no nickname
    assert "merged3" in submission
    m = submission["merged3"]
    assert set(m["dog"]) == DOGS_2
    assert len(m) == 5
    assert m.loc[m["dog"] == "Arya", "nickname"].isna().all()


# Question 3d ------------------------------------------------------------------
def test_3d_merged4_is_complete(submission):
    # Complete rows only: Charlie, Gus, Toni, with no missing values anywhere
    assert "merged4" in submission
    m = submission["merged4"]
    assert set(m["dog"]) == {"Charlie", "Gus", "Toni"}
    assert not m.isna().any().any()


# Question 4a ------------------------------------------------------------------
def test_4a_iris_read_with_letter_columns(submission):
    # 150 flowers, 5 columns named a-e, no header row read in as data
    assert "iris" in submission
    iris = submission["iris"]
    assert list(iris.columns) == ["a", "b", "c", "d", "e"]
    assert iris.shape == (150, 5)
    assert set(iris["e"]) == set(SPECIES_TO_SHORT)


# Question 4b ------------------------------------------------------------------
def test_4b_name_key_maps_long_to_short(submission):
    # 3 x 2 table, right column names, each species paired with its short name
    assert "name_key" in submission
    key = submission["name_key"]
    assert key.shape == (3, 2)
    assert list(key.columns) == ["long name", "short name"]
    assert dict(zip(key["long name"], key["short name"])) == SPECIES_TO_SHORT


# Question 4c ------------------------------------------------------------------
def test_4c_short_names_added_without_overwriting_iris(submission):
    # iris itself is unchanged; the new DataFrame has the right short names
    # and no repeated 'long name' column
    assert list(submission["iris"].columns) == ["a", "b", "c", "d", "e"]
    assert "iris_with_short_names" in submission
    df = submission["iris_with_short_names"]
    assert len(df) == 150
    assert "short name" in df.columns
    assert "long name" not in df.columns
    assert (df["e"].map(SPECIES_TO_SHORT) == df["short name"]).all()


# Question 4d ------------------------------------------------------------------
def test_4d_columns_renamed(submission):
    # First four columns renamed, in order
    df = submission["iris_with_short_names"]
    assert list(df.columns[:4]) == ["s_len", "s_wid", "p_len", "p_wid"]


def test_4d_histogram_figure(submission):
    # A 2 x 2 figure exists and every subplot's x-label names its column
    fig = plt.gcf()
    axes = fig.get_axes()
    assert len(axes) == 4
    labels = {ax.get_xlabel() for ax in axes}
    assert labels == {"s_len", "s_wid", "p_len", "p_wid"}
    for ax in axes:
        assert len(ax.patches) > 0   # bars were actually drawn


# Question 4e ------------------------------------------------------------------
def test_4e_long_iris_shape_and_columns(submission):
    # 150 rows x 5 variables = 750 rows; columns in the required order
    assert "long_iris" in submission
    long_iris = submission["long_iris"]
    assert list(long_iris.columns) == ["row", "variable", "value"]
    assert len(long_iris) == 750


def test_4e_long_iris_sorted_by_row_then_variable(submission):
    # Already sorted: re-sorting by row then variable changes nothing
    long_iris = submission["long_iris"]
    resorted = long_iris.sort_values(["row", "variable"])
    assert list(long_iris.index) == list(resorted.index)


def test_4e_long_iris_values_match_iris(submission):
    # Spot check: row 0's five values equal the first row of iris
    long_iris = submission["long_iris"]
    iris = submission["iris"]
    row0 = long_iris[long_iris["row"] == 0].set_index("variable")["value"]
    for col in ["a", "b", "c", "d", "e"]:
        assert row0[col] == iris.loc[0, col]
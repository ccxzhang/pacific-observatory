from scripts.PdfParse import *

tonga_lsts = os.listdir("data/tourism/tonga")
filepaths = [os.getcwd() + "/data/tourism/tonga/" +
             path for path in tonga_lsts if "Dec" in path]

for file in filepaths:
    print(file)

months = pd.DataFrame()
for file in filepaths[:-1]:
    print(file)
    df = load_pdf(file, "Monthly Arrival and Departure", table_num=-5)
    latest_year, year_idx, month_idx = split_time(df, "Period")
    month = df.iloc[month_idx, 0:4]
    start_year = detect_year(df.iloc[month_idx].iloc[1])
    month = (month.dropna(how="all").reset_index()
             .drop("index", axis=1))
    month = remove_separator(month)
    month = separate_data(month, "Air Ship")
    month = (remove_separator(
        month.iloc[1:].reset_index().drop("index", axis=1)))
    month = month.replace(r'^\s*$', 0, regex=True)

    if check_quality(month, ["Period"]) == False:
        name = file.split("/")[-1].split(".")[0]
        print("  ", name, "could go wrong!")
        generate_time(month, start_year)
        months = pd.concat([months, month], axis=0)

    else:
        generate_time(month, start_year)
        months = pd.concat([months, month], axis=0)


months = (months.drop_duplicates()
                [["Year", "Period", "Air", "Yacht", "Ship", "Total"]]
                .sort_values(by="Year")
                .reset_index()
                .drop("index", axis=1))

months.to_csv("data/tourism/tonga/tonga_monthly_visitor_temp.csv", 
              encoding="utf-8")
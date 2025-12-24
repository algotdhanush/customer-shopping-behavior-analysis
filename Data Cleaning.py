from urllib.parse import quote_plus

import pandas as pd
from sqlalchemy.log import rootlogger

df = pd.read_csv("C:\\Users\\dhanu\\Downloads\\customer_shopping_behavior.csv")
# print(df.head())
# print(df.tail())
# print(df.info())
print(df.describe())

#now see the missing values
print(df.isnull().sum())

#fill the null values with median of that category
df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda a: a.fillna(a.median()))
print(df.isnull().sum())

#need to rewrite the column names with lower case and _
df.columns= df.columns.str.lower()
df.columns= df.columns.str.replace(' ', '_')
df= df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})
print(df.columns)

# create a column age_group
labels = ['Young Adult', 'Adult', 'Middle-Age', 'Senior']
df['age_group']= pd.qcut(df['age'], q=4, labels=labels)

print(df[['age_group', 'age']].head(30))

# Create a column purchase_frequency_days
frequency_mapping= {
    'Fortnightly': 14,
    'Weekly': 7,
    'Quarterly': 30,
    'Bi-Weekly': 14,
    'Annually': 365,
    'Every 3 Months':90,
    'Monthly': 30,
}
df['purchase_frequency_days']= df['frequency_of_purchases'].map(frequency_mapping)
print(df[['purchase_frequency_days','frequency_of_purchases']].head(30))
print(df.shape)

print(df[['discount_applied', 'promo_code_used']].tail(20))
print(df['discount_applied']== df['promo_code_used'])

# #remove the column promo_code_used
df= df.drop('promo_code_used', axis=1)
# df= df.drop(columns=['promo_code_used'])
print(df.columns)

# mysql connection
import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

username = "root"
password = quote_plus("your@password")   # <-- encode special chars like @
host = "127.0.0.1"
port = 3306
database = "Customer_Shopping"

engine = create_engine(
    f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}"
)
with engine.connect() as conn:
    print("Connected successfully!")
#
df.to_sql("customers", engine, if_exists="replace", index=False)
result = pd.read_sql("SELECT * FROM customers", engine)
print(result.head(10))


import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
# %matplotlib inline

df=pd.read_csv("train.csv")
df.shape
df=df.drop(["LotFrontage","Id","GarageYrBlt","PoolQC","RoofMatl","MiscFeature","Electrical","Heating","Utilities"], axis=1)
df.info()

df.head(3)
print(df['SalePrice'].describe())
plt.figure(figsize=(9, 8))

#####Visulaizing training SET
sns.distplot(df['SalePrice'], color='g', bins=100, hist_kws={'alpha': 0.4});
df_no = df.select_dtypes(include = ['float64', 'int64'])
df_no.hist(figsize=(16, 20), bins=50, xlabelsize=8, ylabelsize=8);
df_obj = df.select_dtypes(include = "object")
for i, col in enumerate(df_obj.columns):
    plt.figure(i)
    sns.countplot(x=col, data=df_obj)

df["Alley"].fillna("No Access", inplace = True)
df["FireplaceQu"].fillna("No Fireplace", inplace = True)
df["BsmtQual"].fillna("No Basement", inplace = True)
df["BsmtCond"].fillna("No Basement", inplace = True)
df["BsmtExposure"].fillna("No Basement", inplace = True)
df["BsmtFinType1"].fillna("No Basement", inplace = True)
df["BsmtFinType2"].fillna("No Basement", inplace = True)
df["GarageType"].fillna("No Garage", inplace = True)
df["GarageFinish"].fillna("No Garage", inplace = True)
df["GarageQual"].fillna("No Garage", inplace = True)
df["Fence"].fillna("No Fence", inplace = True)

(df.isnull().sum()/len(df))*100
###Dropping Lot frontage

###Garage built year, garage year cond, mas mas, electrical
#Removing 8 values since it is very less
df=df.dropna(subset=['MasVnrType'])
##Now we have only garage condition.
df["GarageCond"].isnull().sum()
df['GarageCond'].value_counts()
###Replacing them by TA
df["GarageCond"].fillna("TA", inplace = True)
###NOW WE HAVE ZERO NA VALUES

x_train=df.drop(['SalePrice'], axis=1)
y_train=df['SalePrice']
x_train.isnull().sum()

x_train = pd.get_dummies(x_train,columns=x_train.select_dtypes(include=['object']).columns,drop_first=True)

x_train.shape

df0=pd.read_csv("test.csv")
ID=df0["Id"]
df0=df0.drop(["LotFrontage","Id","GarageYrBlt","PoolQC","RoofMatl","MiscFeature","Electrical","Heating","Utilities"], axis=1)
df0.shape

#####Visulaizing training SET
df_no1 = df0.select_dtypes(include = ['float64', 'int64'])
df_no1.hist(figsize=(16, 20), bins=50, xlabelsize=8, ylabelsize=8);
df_obj1 = df0.select_dtypes(include = "object")
for i, col in enumerate(df_obj1.columns):
    plt.figure(i)
    sns.countplot(x=col, data=df_obj1)

df0["Alley"].fillna("No Access", inplace = True)
df0["FireplaceQu"].fillna("No Fireplace", inplace = True)
df0["BsmtQual"].fillna("No Basement", inplace = True)
df0["BsmtCond"].fillna("No Basement", inplace = True)
df0["BsmtExposure"].fillna("No Basement", inplace = True)
df0["BsmtFinType1"].fillna("No Basement", inplace = True)
df0["BsmtFinType2"].fillna("No Basement", inplace = True)
df0["GarageType"].fillna("No Garage", inplace = True)
df0["GarageFinish"].fillna("No Garage", inplace = True)
df0["GarageQual"].fillna("No Garage", inplace = True)
df0["Fence"].fillna("No Fence", inplace = True)

df0.isnull().sum()

#####Treating NA values
df0["MasVnrArea"].describe()
##Filling NA with average of median an mean 137
df0["MasVnrArea"].fillna(137, inplace = True)
##MasVnrType NA Values
df0["MasVnrType"].value_counts()
df0["MasVnrType"].fillna("None", inplace = True)
######Mz zoning
df0["MSZoning"].value_counts()
df0["MSZoning"].fillna("RL", inplace = True)
###Utilities
df0["Exterior1st"].value_counts()
df0["Exterior1st"].fillna("VinylSd", inplace = True)
####Exterior 2nd
df0["Exterior2nd"].value_counts()
df0["Exterior2nd"].fillna("VinylSd", inplace = True)
###Basmt
df0["BsmtFinSF1"].fillna(370, inplace = True)
df0["BsmtFinSF2"].fillna(0, inplace = True)
df0["BsmtUnfSF"].fillna(0, inplace = True)
df0["TotalBsmtSF"].fillna(1000, inplace = True)
###BsmtFullBath
df0["BsmtHalfBath"].value_counts()
df0["BsmtFullBath" ].fillna(1, inplace = True)
df0["BsmtHalfBath" ].fillna(1, inplace = True)
#####KitchenQual
df0["KitchenQual"].value_counts()
df0["KitchenQual"].fillna("TA", inplace = True)
####Functional
df0["Functional"].value_counts()
df0["Functional"].fillna("Typ", inplace = True)
###GarageCars        1
df0["GarageCond"].value_counts()
df0["GarageCars"].fillna(1, inplace = True)
df0["GarageArea"].fillna(250, inplace = True)
df0["GarageCond"].fillna("TA", inplace = True)
###Sale TYPE
df0["SaleType"].value_counts()
df0["SaleType"].fillna("WD", inplace = True)



x_test=df0
x_test = pd.get_dummies(x_test,columns=x_test.select_dtypes(include=['object']).columns,drop_first=True)
x_test.shape

#Checking Missing factors in test set 
set(x_train.columns).difference(x_test.columns)

###Adding missing columns with 0 values
x_test["Condition2_RRAe"]=0
x_test["Condition2_RRAn"]=0
x_test["Condition2_RRNn"]=0
x_test["Exterior1st_Stone"]=0
x_test["Exterior2nd_Other"]=0  
x_test["GarageQual_Fa"]=0 
x_test["Exterior1st_ImStucc"]=0   
x_test["HouseStyle_2.5Fin"]=0        
x_train.isnull().sum()
x_train.shape



from sklearn.ensemble import RandomForestRegressor
regressor=RandomForestRegressor(n_estimators=100)
regressor.fit(x_train, y_train)

y_pred=regressor.predict(x_test)
Final = pd.DataFrame({'Id': ID, 'SalePrice': y_pred})
Final.to_csv("RF1.csv")

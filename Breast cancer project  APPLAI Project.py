#!/usr/bin/env python
# coding: utf-8

# # import the  librarys

# In[3]:


import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# # load the dataset

# In[4]:


df=pd.read_csv('breast-cancer.csv')


# # overview the data set

# In[5]:


df.head(5)


# In[6]:


print(df.info())


# In[7]:


df.describe()


# In[8]:


y = df['diagnosis']
d=df['diagnosis'].value_counts()
d=dict(d)
mylabels =  ['B', 'M']
plt.pie(d.values(), labels = mylabels)
plt.legend(title="category")


# In[9]:


df.duplicated().sum()


# In[10]:


print("mising values: ")
print(df.isnull().sum())


# In[11]:


plt.figure(figsize=(12, 6))
sns.boxplot(data=df)
plt.title('Box Plot of Numerical Columns')
plt.show()


# #  preprocessing
# 

# In[12]:


column_id_data=df['id']


# In[13]:


import numpy as np

def detect_outliers_iqr(column_id_data):
    Q1 = np.percentile(column_id_data, 25)
    Q3 = np.percentile(column_id_data, 75)
    IQR = Q3 - Q1
    lower_bound = Q1 - 1.5 * IQR
    upper_bound = Q3 + 1.5 * IQR
    outliers = (column_id_data < lower_bound) | (column_id_data > upper_bound)
    return outliers

# Example usage:
# col = [1, 2, 3, 4, 5, 100]  # Sample column data
outliers = detect_outliers_iqr(column_id_data)
print("Outliers:", outliers.sum())


# In[14]:


df['diagnosis'].unique()


# In[15]:


# Create a mapping from diagnosis to numeric values
diagnosis_mapping = {
    'M': 2,
    'B': 1,
}

# Map the 'diagnosis' column to numeric values
df['diagnosis'] = df['diagnosis'].map(diagnosis_mapping)


# In[16]:


df.head(100)


# # **************************************************
# 

# # Splitting the dataset into the Training set and Test set
# 
# 

# In[17]:


df.drop(columns=['id'], inplace=True)


# In[18]:


columns_to_pass = df.columns.tolist()
x = df[columns_to_pass[1:]]  # Assuming the first column is to be excluded
y = df[columns_to_pass[0]]    # Assuming the first column is your target column


# In[19]:


print(y)


# In[20]:


print(x)


# In[21]:


from sklearn.feature_selection import VarianceThreshold

x.shape


# In[22]:


VarianceThreshold(.5).fit_transform(x).shape


# In[23]:


df.shape
VarianceThreshold(.5).fit_transform(x).shape
selector = VarianceThreshold(threshold=0.5)
selector.fit(df)
selected_indices = selector.get_support(indices=True)



# In[24]:


selected_columns = df.columns[selected_indices]
removed_columns = df.columns[~selector.get_support()]
print("Columns to be selected:", selected_columns)


# In[25]:


# x = df[['radius_mean', 'texture_mean', 'perimeter_mean', 'area_mean', 'smoothness_mean','compactness_mean','concavity_mean','concave points_mean','symmetry_mean','fractal_dimension_mean','radius_se', 'texture_se','perimeter_se','area_se','smoothness_se','compactness_se','concavity_se','concave points_se','symmetry_se','fractal_dimension_se','radius_worst','texture_worst','perimeter_worst','area_worst','smoothness_worst','compactness_worst','concavity_worst' ]]
# y = df['diagnosis']


# In[26]:


x=df[['radius_mean', 'texture_mean', 'perimeter_mean', 'area_mean','perimeter_se', 'area_se', 'radius_worst', 'texture_worst','perimeter_worst', 'area_worst']]
y =df['diagnosis']


# In[27]:


from sklearn.model_selection import train_test_split
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.2, random_state = 1)


# # Logistic Regression model
# 

# In[28]:


from sklearn.metrics import  classification_report, confusion_matrix

from sklearn.linear_model import LogisticRegression
from sklearn.datasets import make_classification
from sklearn.metrics import accuracy_score
from sklearn.metrics import precision_score


# In[29]:


Logisreg = LogisticRegression()
Logisreg.fit(x_train, y_train)


# In[30]:


y_pred = Logisreg.predict(x_test)


# In[31]:


accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)
# conf_matrix = confusion_matrix(y_test, y_pred)
# print(f'Confusion Matrix:\n{conf_matrix}')
precision = precision_score(y_test, y_pred)
print("Precision:", precision)


# In[32]:


classification_rep = classification_report(y_test, y_pred)
print(f'Classification Report:\n{classification_rep}')


# # knn model
# 

# In[33]:


from sklearn.neighbors import KNeighborsClassifier
knn_model = KNeighborsClassifier(n_neighbors=7)
knn_model.fit(x_train, y_train)


# In[34]:


y_pred = knn_model.predict(x_test)


# In[35]:


accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)
precision = precision_score(y_test, y_pred)
print("Precision:", precision)


# In[36]:


classification_rep = classification_report(y_test, y_pred)
print(f'Classification Report:\n{classification_rep}')


# In[ ]:





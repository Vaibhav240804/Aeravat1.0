import pickle
import nltk
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
import string
import warnings
import sklearn

# Ignore scikit-learn warnings
warnings.filterwarnings("ignore")

def predict_sms(sms_text):
    # Load the saved vectorizer and model
    vectorizer = pickle.load(open('C:/Users/adity/OneDrive/Desktop/Hackathon/Aeravat1.0/SMS SPAM/vectorizer.pkl', 'rb'))
    model = pickle.load(open('C:/Users/adity/OneDrive/Desktop/Hackathon/Aeravat1.0/SMS SPAM/model.pkl', 'rb'))
    
    # Preprocess the input SMS message
    def transform_text(text):
        text = text.lower()
        text = nltk.word_tokenize(text)

        ps = PorterStemmer()
        y = []
        for i in text:
            if i.isalnum():
                y.append(i)

        text = y[:]
        y.clear()

        for i in text:
            if i not in stopwords.words('english') and i not in string.punctuation:
                y.append(i)

        text = y[:]
        y.clear()

        for i in text:
            y.append(ps.stem(i))

        return " ".join(y)

    processed_sms = transform_text(sms_text)
    
    # Vectorize the preprocessed SMS message
    sms_vectorized = vectorizer.transform([processed_sms])
    
    # Make prediction using the loaded model
    prediction = model.predict(sms_vectorized)
    
    # Return the prediction
    if prediction[0] == 1:
        return "Spam"
    else:
        return "Not Spam"

    
# Example usage:
sms_text = "hi"
prediction = predict_sms(sms_text)
print(prediction)

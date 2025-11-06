import streamlit as st
import joblib
import pandas as pd
import time

# -----------------------------------------
# 🎨 Page Configuration
# -----------------------------------------
st.set_page_config(
    page_title="E-Commerce Return Predictor 🛒",
    page_icon="🧠",
    layout="centered",
    initial_sidebar_state="collapsed"
)

# -----------------------------------------
# 💅 Custom CSS Styling
# -----------------------------------------
st.markdown("""
    <style>
        /* Main page */
        .main {
            background: linear-gradient(135deg, #f3f9ff 0%, #e3f0ff 100%);
            color: #0e1117;
            font-family: "Poppins", sans-serif;
        }

        /* Title style */
        .title {
            text-align: center;
            color: #1E3A8A;
            font-size: 36px;
            font-weight: bold;
            text-shadow: 2px 2px 8px rgba(30, 58, 138, 0.2);
        }

        /* Subheader */
        .subheader {
            color: #0369A1;
            font-size: 20px;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        /* Buttons */
        div.stButton > button {
            background: linear-gradient(to right, #2563EB, #1E40AF);
            color: white;
            border-radius: 12px;
            padding: 10px 20px;
            font-size: 18px;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.3);
            transition: 0.3s;
        }

        div.stButton > button:hover {
            background: linear-gradient(to right, #1E3A8A, #2563EB);
            transform: scale(1.05);
        }

        /* Success and error boxes */
        .success-box, .error-box {
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            font-size: 20px;
            font-weight: 600;
            margin-top: 25px;
        }
        .success-box {
            background-color: #DCFCE7;
            color: #166534;
            border: 2px solid #22C55E;
        }
        .error-box {
            background-color: #FEE2E2;
            color: #991B1B;
            border: 2px solid #DC2626;
        }
    </style>
""", unsafe_allow_html=True)

# -----------------------------------------
# 🚀 Load Model
# -----------------------------------------
st.markdown('<h1 class="title">🛒 E-Commerce Product Return Predictor</h1>', unsafe_allow_html=True)

try:
    model = joblib.load('return_predictor_2.pkl')
    st.success("✅ Model loaded successfully!")
except Exception as e:
    st.error(f"❌ Failed to load model: {e}")
    st.stop()

# -----------------------------------------
# 🧩 Input Section
# -----------------------------------------
st.markdown('<h3 class="subheader">📦 Enter Order Details</h3>', unsafe_allow_html=True)

col1, col2 = st.columns(2)

with col1:
    price = st.number_input("💰 Price", min_value=0.0)
    discount = st.number_input("💸 Discount (%)", min_value=0.0, max_value=100.0)
    quantity = st.number_input("🧮 Quantity", min_value=1)
    delivery_time = st.number_input("⏱️ Delivery Time (Days)", min_value=1)
    total_amount = st.number_input("📊 Total Amount", min_value=0.0)

with col2:
    profit_margin = st.number_input("📈 Profit Margin", min_value=0.0)
    shipping_cost = st.number_input("🚚 Shipping Cost", min_value=0.0)
    customer_age = st.number_input("👤 Customer Age", min_value=18, max_value=70)
    category = st.selectbox("🏷️ Category", ['Electronics', 'Fashion', 'Home', 'Beauty', 'Sports', 'Toys', 'Grocery'])
    region = st.selectbox("🌍 Region", ['North', 'South', 'East', 'West', 'Central'])
    payment_method = st.selectbox("💳 Payment Method", ['Credit Card', 'Debit Card', 'UPI', 'PayPal', 'Wallet'])
    customer_gender = st.selectbox("⚧️ Gender", ['Male', 'Female'])

# -----------------------------------------
# 🔮 Prediction
# -----------------------------------------
if st.button("🚀 Predict Return Probability"):
    with st.spinner("🔍 Analyzing data... Please wait..."):
        time.sleep(1.5)

        # Prepare input data
        input_data = pd.DataFrame([{
            'price': price,
            'discount': discount,
            'quantity': quantity,
            'delivery_time_days': delivery_time,
            'total_amount': total_amount,
            'profit_margin': profit_margin,
            'shipping_cost': shipping_cost,
            'customer_age': customer_age,
            'category': category,
            'region': region,
            'payment_method': payment_method,
            'customer_gender': customer_gender
        }])

        # Predict
        prediction = model.predict(input_data)[0]
        probability = model.predict_proba(input_data)[0][1] * 100

    st.markdown("### 🎯 Prediction Result")
    st.progress(int(probability))

    # Result display
    if prediction == 1:
        st.markdown(
            f'<div class="error-box">⚠️ Product is <b>likely to be RETURNED</b><br>Probability: {probability:.2f}%</div>',
            unsafe_allow_html=True)
    else:
        st.markdown(
            f'<div class="success-box">✅ Product is <b>NOT likely to be returned</b><br>Probability: {probability:.2f}%</div>',
            unsafe_allow_html=True)

    st.balloons()

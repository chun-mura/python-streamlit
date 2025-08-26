import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px

# ページ設定
st.set_page_config(
    page_title="Streamlit Docker App",
    page_icon="🚀",
    layout="wide"
)

# タイトル
st.title("🚀 Streamlit Docker アプリケーション")
st.markdown("---")

# サイドバー
st.sidebar.header("設定")
chart_type = st.sidebar.selectbox(
    "グラフの種類を選択",
    ["折れ線グラフ", "棒グラフ", "散布図", "ヒストグラム"]
)

# メインコンテンツ
col1, col2 = st.columns(2)

with col1:
    st.subheader("データ生成")
    # サンプルデータの生成
    np.random.seed(42)
    dates = pd.date_range('2023-01-01', periods=100, freq='D')
    data = np.random.randn(100).cumsum()
    df = pd.DataFrame({'日付': dates, '値': data})

    st.dataframe(df.head())

    # 統計情報
    st.subheader("統計情報")
    st.write(f"平均値: {df['値'].mean():.2f}")
    st.write(f"標準偏差: {df['値'].std():.2f}")
    st.write(f"最小値: {df['値'].min():.2f}")
    st.write(f"最大値: {df['値'].max():.2f}")

with col2:
    st.subheader("グラフ表示")

    if chart_type == "折れ線グラフ":
        fig = px.line(df, x='日付', y='値', title='時系列データ')
        st.plotly_chart(fig, use_container_width=True)

    elif chart_type == "棒グラフ":
        # 月別の平均値を計算
        monthly_data = df.set_index('日付').resample('M').mean()
        fig = px.bar(monthly_data, title='月別平均値')
        st.plotly_chart(fig, use_container_width=True)

    elif chart_type == "散布図":
        # ラグデータを作成
        df['値_ラグ'] = df['値'].shift(1)
        fig = px.scatter(df.dropna(), x='値_ラグ', y='値', title='自己相関散布図')
        st.plotly_chart(fig, use_container_width=True)

    elif chart_type == "ヒストグラム":
        fig = px.histogram(df, x='値', title='値の分布', nbins=20)
        st.plotly_chart(fig, use_container_width=True)

# フッター
st.markdown("---")
st.markdown("**Docker環境で動作中のStreamlitアプリケーション**")
st.markdown("このアプリケーションは、DockerとDocker Composeを使用して構築されています。")

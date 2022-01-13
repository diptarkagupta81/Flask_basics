from flask import Flask,send_file,redirect,url_for,render_template
import io
import base64
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
import matplotlib.pyplot as plt
import seaborn as sns

fig,ax=plt.subplots(figsize=(6,6))
ax=sns.set_style(style="darkgrid")

x=[8,10,34,60]
y=[2,6,40,60]

app=Flask(__name__)

@app.route('/')
def home():
    return render_template("index.html",content="DIPTARKA")

@app.route('/visualize')
def visualize():
    sns.lineplot(x,y)
    canvas=FigureCanvas(fig)
    img=io.BytesIO()
    fig.savefig(img)
    img.seek(0)
    return send_file(img,mimetype='img/png')

if __name__=='__main__':
    app.run()

from flask import Flask, request, render_template, Markup, send_from_directory, session, flash

import os
import mysql.connector
import plotly
from plotly.graph_objs import Scatter, Layout
import logging
from datetime import datetime, timedelta
import pytz
from datetime import datetime
import re

app = Flask(__name__)
app.secret_key = "<g\x93E\xf3\xc6\xb8\xc4\x87\xff\xf6\x0fxD\x91\x13\x9e\xfe1+%\xa3\x83\xb6"

def connectToMySql():
    mydb = mysql.connector.connect(
        host="localhost",
        user="root1234",
        password="OlOlO1234",
        database="new_wheatherstation"
    )

    return mydb

def findData(pattern, data):
    return re.match(pattern, data).group(1)

def saveWeatherData(workshop, worker, temp, hum, ppm, date):
    result = False
    mydb = connectToMySql()
    try:
        mycursor = mydb.cursor()
        sql = f"INSERT INTO climate (date, workshop_id, worker_id, temperature, humidity, ppm) VALUES ('{date}', {workshop}, {worker}, {temp}, {hum}, {ppm})"
        mycursor.execute(sql)
        mydb.commit()
        print(mycursor.rowcount, "record inserted.")
        if mycursor.rowcount > 0:
            result = True
        mydb.close()
    except:
        mydb.close()
    return result

def getLatestWeatherData():
    mydb = connectToMySql()
    try:
        mycursor = mydb.cursor()
        workshop_numbers = [1, 2, 3, 4]

        query_list = []
        for workshop in workshop_numbers:
            query = f"SELECT date, data FROM room_logs where roomid = {str(workshop)} ORDER BY date DESC LIMIT 1"
            query_list.append(query)

        mycursor.execute(query_list[0])
        result_freeze = mycursor.fetchall()
        mycursor.execute(query_list[1])
        result_plant_1 = mycursor.fetchall()
        mycursor.execute(query_list[2])
        result_plant_2 = mycursor.fetchall()
        mycursor.execute(query_list[3])
        result_compost = mycursor.fetchall()
        mydb.close()
    except:
        mydb.close()
        result_plant_1 = False
        result_plant_2 = False
        result_freeze = False
        result_compost = False

    return result_freeze, result_plant_1, result_plant_2, result_compost

def checkSystemOn():
    systemOn = False
    IST = pytz.timezone('Europe/Rome')
    datetime_utc = datetime.now(IST)
    latestData = getLatestWeatherData()[0]
    lastDate = latestData[0][0]
    currentDateTime = datetime_utc.replace(tzinfo=None)
    lastDateTime = lastDate.replace(tzinfo=None)
    diffBetweenDates = currentDateTime-lastDateTime
    if diffBetweenDates > timedelta(minutes=15):
        systemOn = False
    else:
        systemOn = True
    return systemOn

def getSpecificData(dataToSelect, workshop):

    pattern_temp = r'\S?T=(\d+\D?\d?);'
    pattern_hum = r'\S+?H=(\d+\D?\d?);'
    pattern_ppm = r'\S+?P=(\d+\D?\d?);'

    mydb = connectToMySql()
    mycursor = mydb.cursor()

    query = f"SELECT date, data FROM room_logs WHERE roomid = {str(workshop)} ORDER BY date"

    mycursor.execute(query)
    data = mycursor.fetchall()
    mydb.close()
    print(data)
    if dataToSelect == 'Temperature':
        result = []
        for el in data:
            # print(el[1])
            lst = []
            lst.append(el[0])
            lst.append(re.match(pattern_temp, el[1]).group(1))
            result.append(lst)
            
    elif dataToSelect == 'Humidity':
        result = []
        for el in data:
            # print(el[1])
            lst = []
            lst.append(el[0])
            lst.append(re.match(pattern_hum, el[1]).group(1))
            result.append(lst)
    elif dataToSelect == 'Ppm':
        result = []
        for el in data:
            # print(el[1])
            lst = []
            lst.append(el[0])
            lst.append(re.match(pattern_ppm, el[1]).group(1))
            result.append(lst)
    return result

def createPlot(datas, dataType):
    if dataType == 'Temperature':
        plotColor = '#ff9900'
        plotTitle = 'Температура'
    elif dataType == 'Humidity':
        plotColor = '#029400'
        plotTitle = 'Влажность'
    elif dataType == 'Ppm':
        plotColor = '#70bfff'
        plotTitle ='Углекислый газ'
    elif dataType == 'Temperature1':
        plotColor = '#029410'
        plotTitle = 'Влажность'
    elif dataType == 'Temperature2':
        plotColor = '#029420'
        plotTitle = 'Влажность'

    dataDictionary = {
        "X": [],
        "Y": []
    }
    # datas.sorted()
    for x in datas:
        dataDictionary["X"].append(x[0])
        dataDictionary["Y"].append(x[1])
    plot = plotly.offline.plot({
        "data": [Scatter(x=dataDictionary["X"], y=dataDictionary["Y"], line=dict(color=plotColor, width=2))],
        "layout": Layout(title=plotTitle, width=520, height=600, margin=dict(
            l=50,
            r=50,
            b=100,
            t=100,
            pad=4
        ))
    }, output_type='div'
    )

    return plot

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'), 'favicon.ico', mimetype='image/vnd.microsoft.icon')

@app.route('/')
def climatePage():
    if not session.get('logged_in'):
        return render_template('login.html')
    else:
        #get latest sensor datas
        latestWeatherData = getLatestWeatherData()
        latestData_freeze = latestWeatherData[0]
        latestData_plant_1 = latestWeatherData[1]
        latestData_plant_2 = latestWeatherData[2]
        latestData_compost = latestWeatherData[3]

        pattern_temp = r'\S?T=(\d+\D?\d?);'
        pattern_hum = r'\S+?H=(\d+\D?\d?);'
        pattern_ppm = r'\S+?P=(\d+\D?\d?);'

        lastDataTime = latestData_plant_1[0][0]

        lastTemperature_freeze = findData(pattern_temp, latestData_freeze[0][1])
        lastHumidity_freeze = findData(pattern_hum, latestData_freeze[0][1])
        lastPpm_freeze = findData(pattern_ppm, latestData_freeze[0][1])

        lastTemperature_plant_1 = findData(pattern_temp, latestData_plant_1[0][1])
        lastTemperature_plant_2 = findData(pattern_temp, latestData_plant_2[0][1])
        lastHumidity_plant_1 = findData(pattern_hum, latestData_plant_1[0][1])      
        lastHumidity_plant_2 = findData(pattern_hum, latestData_plant_2[0][1])
        lastPpm_plant_1 = findData(pattern_ppm, latestData_plant_1[0][1])     
        lastPpm_plant_2 = findData(pattern_ppm, latestData_plant_2[0][1])

        lastTemperature_compost = findData(pattern_temp, latestData_compost[0][1])
        lastHumidity_compost = findData(pattern_hum, latestData_compost[0][1])
        lastPpm_compost = findData(pattern_ppm, latestData_compost[0][1])
        #get data to build temperatures plot

        # FREEZE
        table = 'freeze_table'
        temperatures_freeze = getSpecificData("Temperature", 1)
        temperaturesPlot_freeze = createPlot(temperatures_freeze, "Temperature")
        temperaturesPlotHtml_freeze = Markup(temperaturesPlot_freeze)
        
        humidity_freeze = getSpecificData("Humidity", 1)
        humidityPlot_freeze = createPlot(humidity_freeze, "Humidity")
        humidityPlotHtml_freeze = Markup(humidityPlot_freeze)
        
        ppm_freeze = getSpecificData("Ppm", 1)
        ppmPlot_freeze = createPlot(ppm_freeze, "Ppm")
        ppmPlotHtml_freeze = Markup(ppmPlot_freeze)

        # PLANT
        table = 'plant_table'
        temperatures_plant_1 = getSpecificData("Temperature", 2)
        temperaturesPlot_plant_1 = createPlot(temperatures_plant_1, "Temperature")
        temperaturesPlotHtml_plant_1 = Markup(temperaturesPlot_plant_1)

        temperatures_plant_2 = getSpecificData("Temperature", 3)
        temperaturesPlot_plant_2 = createPlot(temperatures_plant_2, "Temperature")
        temperaturesPlotHtml_plant_2 = Markup(temperaturesPlot_plant_2)
        
        humidity_plant_1 = getSpecificData("Humidity", 2)
        humidityPlot_plant_1 = createPlot(humidity_plant_1, "Humidity")
        humidityPlotHtml_plant_1 = Markup(humidityPlot_plant_1)

        humidity_plant_2 = getSpecificData("Humidity", 3)
        humidityPlot_plant_2 = createPlot(humidity_plant_2, "Humidity")
        humidityPlotHtml_plant_2 = Markup(humidityPlot_plant_2)
        
        ppm_plant_1 = getSpecificData("Ppm", 2)
        ppmPlot_plant_1 = createPlot(ppm_plant_1, "Ppm")
        ppmPlotHtml_plant_1 = Markup(ppmPlot_plant_1)

        ppm_plant_2 = getSpecificData("Ppm", 3)
        ppmPlot_plant_2 = createPlot(ppm_plant_2, "Ppm")
        ppmPlotHtml_plant_2 = Markup(ppmPlot_plant_2)

        # COMPOST
        table = 'compost_table'
        temperatures_compost = getSpecificData("Temperature", 4)
        temperaturesPlot_compost = createPlot(temperatures_compost, "Temperature")
        temperaturesPlotHtml_compost = Markup(temperaturesPlot_compost)
        
        humidity_compost = getSpecificData("Humidity", 4)
        humidityPlot_compost = createPlot(humidity_compost, "Humidity")
        humidityPlotHtml_compost = Markup(humidityPlot_compost)
        
        ppm_compost = getSpecificData("Ppm", 4)
        ppmPlot_compost = createPlot(ppm_compost, "Ppm")
        ppmPlotHtml_compost = Markup(ppmPlot_compost)

        systemOn = checkSystemOn()

        return render_template("climate.html", 
                               lastDataTime=lastDataTime, 
                               lastTemperature_freeze=lastTemperature_freeze, 
                               lastTemperature_plant_1=lastTemperature_plant_1,                                
                               lastTemperature_plant_2=lastTemperature_plant_2, 
                               lastTemperature_compost=lastTemperature_compost, 
                               lastHumidity_freeze=lastHumidity_freeze,
                               lastHumidity_plant_1=lastHumidity_plant_1,
                               lastHumidity_plant_2=lastHumidity_plant_2,
                               lastHumidity_compost=lastHumidity_compost,
                               lastPpm_freeze=lastPpm_freeze, 
                               lastPpm_plant_1=lastPpm_plant_1, 
                               lastPpm_plant_2=lastPpm_plant_2, 
                               lastPpm_compost=lastPpm_compost, 
                               temperaturePlot_freeze=temperaturesPlotHtml_freeze, 
                               temperaturePlot_plant_1=temperaturesPlotHtml_plant_1,                                
                               temperaturePlot_plant_2=temperaturesPlotHtml_plant_2, 
                               temperaturesPlot_compost=temperaturesPlotHtml_compost, 
                               humidityPlot_freeze=humidityPlotHtml_freeze,                                
                               humidityPlot_plant_1=humidityPlotHtml_plant_1, 
                               humidityPlot_plant_2=humidityPlotHtml_plant_2, 
                               humidityPlot_compost=humidityPlotHtml_compost,  
                               ppmPlot_freeze=ppmPlotHtml_freeze,                                
                               ppmPlot_plant_1=ppmPlotHtml_plant_1, 
                               ppmPlot_plant_2=ppmPlotHtml_plant_2, 
                               ppmPlot_compost=ppmPlotHtml_compost, 
                               systemOn=systemOn)

@app.route('/login', methods=['POST'])
def do_admin_login():
    mydb = connectToMySql()
    mycursor = mydb.cursor()
    try:
        query = f"SELECT id FROM user_profile WHERE email = '{request.form['email']}' AND password = MD5('{request.form['password']}')"
        mycursor.execute(query)
        result = mycursor.fetchall()
        if result[0][0]>0:
            session['logged_in'] = True
    except IndexError:
        flash('Неверный email или password!')
    except Exception as e: print(e)
    mydb.close()
    return climatePage()

@app.route("/logout", methods=['POST'])
def logout():
    session['logged_in'] = False
    return render_template('login.html')

#example query: /postWeatherData?Temp=3.4&Hum=86.4&Ppm=455.8&Workshop=1&Worker=2
@app.route('/postWeatherData', methods=['GET', 'POST'])
def postWeatherData():
    if request.method == 'GET':
        temperature = request.args.get('Temp')
        humidity = request.args.get('Hum')
        ppm = request.args.get('Ppm')
        # date = request.args.get('Date')
        workshop = request.args.get('Workshop')
        worker = request.args.get('Worker')
        print("New Weather Data. T:" + temperature + " H:" + humidity + " P:" + ppm + " Workshop:" + workshop + " Worker:" + worker)
        current_datetime = datetime.now()
        seychas_data = str(current_datetime.date()) + ' ' + str(current_datetime.time())[:5]
        print(str(current_datetime.date()) + ' ' + str(current_datetime.time())[:5])
        if float(temperature) > -14 and float(temperature) < 90 and float(humidity) > 4 and float(humidity) < 1200:
            insertResult = saveWeatherData(workshop, worker, temperature, humidity, ppm, seychas_data)
            print("postWeatherData result: " + str(insertResult))
        else:
            logging.info("Weather data values out of range (esp temperature sensor error). Weather Data received:  T:" + temperature + " H:" + humidity + " P:" + ppm + " Date:" + date + " Time:" + time + "Workshop:" + workshop + "Worker:" + worker)
        # return redirect('/')
    return 'ok'

if __name__ == '__main__':
    app.env = "debug"
    app.debug = False
    app.run(host='192.168.0.7')
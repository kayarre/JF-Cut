/**
 * COPYRIGHT NOTICE
 * Copyright (c) 2012, Institute of CG & CAD, Tsinghua University.
 * All Rights Reserved.
 * 
 * @file    QMain.cpp
 * @brief   QVisualizer entry point.
 * 
 * This file defines the entry point of QVisualizer, which initialize the UI and enter the message loop.
 * 
 * @version 1.0
 * @author  Jackie Pang
 * @e-mail  15pengyi@gmail.com
 * @date    2013/11/06
 */

#ifndef __GLEW
#define __GLEW
#include <GL/glew.h>
#endif

//#include <QtGui>
#include <QApplication>
#include <QStyleFactory>
//#include <QCleanlooksStyle>
#include "QGCVisualizer.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setStyle(QStyleFactory::create("Fusion"));
    //a.setStyle(new QCleanlooksStyle());

    QGCVisualizer w;
    w.show();
    
    return a.exec();
}

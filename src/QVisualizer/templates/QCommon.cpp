/**
 * COPYRIGHT NOTICE
 * Copyright (c) 2012, Institute of CG & CAD, Tsinghua University.
 * All Rights Reserved.
 * 
 * @file    QCommon.cpp
 * @brief   QCommon class declaration.
 * 
 * This file declares the initialization methods for the components defined in QCommon.h.
 * 
 * @version 1.0
 * @author  Edgar Liao, Jackie Pang
 * @e-mail  15pengyi@gmail.com
 * @date    2012/02/07
 */

#include "QCommon.h"

QCommon::QCommon() :
    render_(NULL), parent_(NULL), panel_(NULL)
{}

QCommon::QCommon(QWidget* parent, Qt::WindowFlags flags) :
    render_(NULL), parent_(parent), panel_(NULL)
{}

QCommon::~QCommon()
{}

QWidget* QCommon::getParent()
{
    return parent_;
}

QWidget* QCommon::getRender()
{
    return render_;
}

QWidget* QCommon::getPanel()
{
    return panel_;
}

struct Menu* QCommon::getMenus()
{
    return &menus_;
}

void QCommon::initConnections()
{}

void QCommon::initMenus()
{}

void QCommon::initPanels()
{}

//
//  CardNetwork.h
//  JudoKitObjC
//
//  Copyright (c) 2016 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

typedef NS_ENUM(NSUInteger, CardNetwork) {
    /// Unknown
    CardNetworkUnknown = 0,
    /// Visa Card Network
    CardNetworkVisa = 1,
    /// MasterCard Network
    CardNetworkMasterCard = 2,
    /// Visa Electron Network
    CardNetworkVisaElectron = 3,
    /// Switch Network
    CardNetworkSwitch = 4,
    /// Solo Network
    CardNetworkSolo = 5,
    /// Laser Network
    CardNetworkLaser = 6,
    /// China UnionPay Network
    CardNetworkChinaUnionPay = 7,
    /// American Express Card Network
    CardNetworkAMEX = 8,
    /// JCB Network
    CardNetworkJCB = 9,
    /// Maestro Card Network
    CardNetworkMaestro = 10,
    /// Visa Debit Card Network
    CardNetworkVisaDebit = 11,
    /// MasterCard Network
    CardNetworkMasterCardDebit = 12,
    /// Visa Purchasing Network
    CardNetworkVisaPurchasing = 13,
    /// Discover Network
    CardNetworkDiscover = 14,
    /// Carnet Network
    CardNetworkCarnet = 15,
    /// Carte Bancaire Network
    CardNetworkCarteBancaire = 16,
    /// Diners Club Network
    CardNetworkDinersClub = 17,
    /// Elo Network
    CardNetworkElo = 18,
    /// Farmers Card Network
    CardNetworkFarmersCard = 19,
    /// Soriana Network
    CardNetworkSoriana = 20,
    /// Private Label Card Network
    CardNetworkPrivateLabelCard = 21,
    /// Q Card Network
    CardNetworkQCard = 22,
    /// Style Network
    CardNetworkStyle = 23,
    /// True Rewards Network
    CardNetworkTrueRewards = 24,
    /// UATP Network
    CardNetworkUATP = 25,
    /// Bank Card Network
    CardNetworkBankCard = 26,
    /// Banamex Costco Network
    CardNetworkBanamex_Costco = 27,
    /// InterPayment Network
    CardNetworkInterPayment = 28,
    /// InstaPayment Network
    CardNetworkInstaPayment = 29,
    /// Dankort Network
    CardNetworkDankort = 30
};

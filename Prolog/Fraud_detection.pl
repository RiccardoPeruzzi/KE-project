%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%KE prolog exam Lerco Peruzzi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%Assertions

belongs(albania, europe).
belongs(andorra, europe).
belongs(austria, europe).
belongs(belarus, europe).
belongs(belgium, europe).
belongs(bosnia_and_herzegovina, europe).
belongs(bulgaria, europe).
belongs(croatia, europe).
belongs(cyprus, europe).
belongs(czech_republic, europe).
belongs(denmark, europe).
belongs(estonia, europe).
belongs(finland, europe).
belongs(france, europe).
belongs(germany, europe).
belongs(greece, europe).
belongs(hungary, europe).
belongs(iceland, europe).
belongs(ireland, europe).
belongs(italy, europe).
belongs(kosovo, europe).
belongs(latvia, europe).
belongs(liechtenstein, europe).
belongs(lithuania, europe).
belongs(luxembourg, europe).
belongs(malta, europe).
belongs(moldova, europe).
belongs(monaco, europe).
belongs(montenegro, europe).
belongs(netherlands, europe).
belongs(north_macedonia, europe).
belongs(norway, europe).
belongs(poland, europe).
belongs(portugal, europe).
belongs(romania, europe).
belongs(russia, europe).
belongs(san_marino, europe).
belongs(serbia, europe).
belongs(slovakia, europe).
belongs(slovenia, europe).
belongs(spain, europe).
belongs(sweden, europe).
belongs(switzerland, europe).
belongs(ukraine, europe).
belongs(united_kingdom, europe).
belongs(vatican_city, europe).

belongs(algeria, africa).
belongs(angola, africa).
belongs(benin, africa).
belongs(botswana, africa).
belongs(burkina_faso, africa).
belongs(burundi, africa).
belongs(cabo_verde, africa).
belongs(cameroon, africa).
belongs(central_african_republic, africa).
belongs(chad, africa).
belongs(comoros, africa).
belongs(democratic_republic_of_the_congo, africa).
belongs(djibouti, africa).
belongs(egypt, africa).
belongs(equatorial_guinea, africa).
belongs(eritrea, africa).
belongs(eswatini, africa).
belongs(ethiopia, africa).
belongs(gabon, africa).
belongs(gambia, africa).
belongs(ghana, africa).
belongs(guinea, africa).
belongs(guinea_bissau, africa).
belongs(ivory_coast, africa).
belongs(kenya, africa).
belongs(lesotho, africa).
belongs(liberia, africa).
belongs(libya, africa).
belongs(madagascar, africa).
belongs(malawi, africa).
belongs(mali, africa).
belongs(mauritania, africa).
belongs(mauritius, africa).
belongs(morocco, africa).
belongs(mozambique, africa).
belongs(namibia, africa).
belongs(niger, africa).
belongs(nigeria, africa).
belongs(republic_of_the_congo, africa).
belongs(rwanda, africa).
belongs(sao_tome_and_principe, africa).
belongs(senegal, africa).
belongs(seychelles, africa).
belongs(sierra_leone, africa).
belongs(somalia, africa).
belongs(south_africa, africa).
belongs(south_sudan, africa).
belongs(sudan, africa).
belongs(tanzania, africa).
belongs(togo, africa).
belongs(tunisia, africa).
belongs(uganda, africa).
belongs(zambia, africa).
belongs(zimbabwe, africa).

continent(Country, europe):-belongs(Country, europe).
continent(Country, africa):-belongs(Country, africa).

%cardholder(Id, Name, Country).
%merchant(Id, Name, Country, Storetype).
%transaction(TransactionID, CardholderID, MerchanID, Amount, Timestamp).

%facts
cardholder(c1, mensoni, italy).
cardholder(c2, meyer, germany).
cardholder(c3, suter, switzerland).
cardholder(c4, abba, tanzania).
cardholder(c5, miller, germany).

creditcard(c1, 1111).
creditcard(c2, 2222).
creditcard(c3, 3333).
creditcard(c4, 4444).
creditcard(c5, 5555).

merchant(m1, worldofafrica, south_africa, phisical).
merchant(m2, windsofthedeserts, morocco, phisical).
merchant(m3, mamaafrica, south_africa, phisical).
merchant(m4, southAfricaMasterPieces, south_africa, online).



transaction(tx1, 1111, m1, 11234, 1715097900). %ora sono le 18.05 07.05.2026
transaction(tx2, 2222, m2, 12, 1715097950).
transaction(tx3, 3333, m3, 90, 1715098950).

%tx1,tx4 suspected
transaction(tx4, 1111, m2, 12, 1715097950).

%tx1, tx5 not suspected
transaction(tx5, 1111, m2, 12, 1715098950).
%rules
transaction(tx6, 5555, m4, 102, 1780783600).

%%%%%%%%%%%%%%%%%%%%%%%
%Type sorter
%%%%%%%%%%%%%%%%%%%%%%%
transactionType(Trans, a):- 
    transaction(Trans, _, MerchantID, _, _),
    merchant(MerchantID, _, _, online).

transactionType(Trans, b) :-
    transaction(Trans, _, _, _, _),
    \+ transactionType(Trans, a).

%allTransaction(Type,Transactions):-
    
    

%%%%%%%%%%%%%%%%%%%%%%%
%Merchant location risk
%%%%%%%%%%%%%%%%%%%%%%%

merchant_risk(Country, 10) :-
    Country = italy.

merchant_risk(Country, 20) :-
    Country \= italy,
    belongs(Country, europe), !.

merchant_risk(Country, 60) :-
    belongs(Country, africa), !.

merchant_risk(_,0).

%%%%%%%%%%%%%%%%%%%%%%%
%Carholder Risk
%%%%%%%%%%%%%%%%%%%%%%%

cardholder_risk(Country, 0):-
    Country = italy.

cardholder_risk(Country, 10):-
    Country \= italy,
    belongs(Country, europe), !.

cardholder_risk(Country, 20) :-
    belongs(Country, africa), !.

cardholder_risk(_,0).

%%%%%%%%%%%%%%%%%%%%%%%
%Amount risk
%%%%%%%%%%%%%%%%%%%%%%%

amount_risk(Amount, 10):-
    Amount < 1000,!.

amount_risk(Amount, 60):-
    Amount >= 1000,
    Amount =< 10000,!.

amount_risk(Amount, 90):-
    Amount > 10000,!.


%%%%%%%%%%%%%%%%%%%%%%%
%Special Risk
%%%%%%%%%%%%%%%%%%%%%%%   	

special_risk(Cardholder, Merchant, 30) :-
    Cardholder = switzerland,
    Merchant = south_africa,!.

special_risk(_,_,0).


%%%%%%%%%%%%%%%%%%%%%%%
%summation
%%%%%%%%%%%%%%%%%%%%%%%   	

score_risk(TransactionID, Score) :-
    transaction(TransactionID, Cardnumber, MerchantID, Amount, _ ),
    creditcard(CardholderID, Cardnumber),
    cardholder(CardholderID, _ , CardholderCountry),
    merchant(MerchantID, _ , MerchantCountry,_),
    cardholder_risk(CardholderCountry, CR),
    merchant_risk(MerchantCountry, MR),
    amount_risk(Amount, AR),
    special_risk(CardholderCountry, MerchantCountry, SR),
    time_comparison(TransactionID, TC),
    Score is CR + MR + AR + SR +TC.

    
%%%%%%%%%%%%%%%%%%%%%%%
%Detection
%%%%%%%%%%%%%%%%%%%%%%% 

detect(TransactionID, accepted, Score):-
    score_risk(TransactionID, Score),
    Score =< 100.

detect(TransactionID, stopped, Score):-
    score_risk(TransactionID, Score),
    Score > 100,
    Score < 150.

detect(TransactionID, rejected, Score):-
    score_risk(TransactionID, Score),
    Score >= 150.
    


%%%%%%%%%%%%%%%%%%%%%%%
%Transaction comparison
%%%%%%%%%%%%%%%%%%%%%%% 

score_risk_comparison(T1, T2):-
    transaction(T1, Cardnumber, Merchant1, _, Time1),
    transaction(T2, Cardnumber, Merchant2, _, Time2),
    merchant(Merchant1, _, Country1, phisical),
    merchant(Merchant2, _, Country2, phisical),
    T1 \= T2,
    Country1 \= Country2,
    D is abs(Time1-Time2),
    D =< 300.
    %score_risk(T1, Score),
    %Result is max(Score, 150),!.

time_comparison(T, 150) :-
    transaction(T, _,_,_,_),
    score_risk_comparison(T,_),!.

time_comparison(_, 0).


%%%%%%%%%%%%%%%%%%%%%%%
%Use instruction
%%%%%%%%%%%%%%%%%%%%%%% 

%After saving some transaction just type

%detect(TransactionIDtoCheck, Variable(Result), Variable(Score)).

%Example
% detect(tx1, X, Y).

















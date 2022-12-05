/*Project title:Credit card loan eligibility*/
set serveroutput on;

--creating the credit card loan details
CREATE TABLE loan_for_creditcard (
    phone              NUMBER(20),
    credit_card_number NUMBER(20),
    loan_eligibility   CHAR(1),
    loan_amount        NUMBER(20)
);
                              
--inserting the data into the table.

INSERT INTO loan_for_creditcard VALUES (
    9392327586,
    1234123412346666,
    'Y',
    100000
);

INSERT INTO loan_for_creditcard VALUES (
    9392327586,
    1234123412347777,
    'N',
    100000
);

INSERT INTO loan_for_creditcard VALUES (
    7981275926,
    1234123412345555,
    'Y',
    100000
);

INSERT INTO loan_for_creditcard VALUES (
    7981275926,
    1234123412343333,
    'N',
    100000
);

COMMIT;

SELECT
    *
FROM
    loan_for_creditcard;



--Loan eligibility check procedure
/*Create procedure to check loan eligibility amount by passing
                        Ph Num and Credit Card Number as input and one output message:
                        We need to check below conditions:
                        1.To validate the Phone number and credit card.
                        2.To check any offers are there or not.
                        3.If offers are there need to display the loan amount.*/


CREATE OR REPLACE PROCEDURE eligibility_for_loan (
    p_phone     NUMBER,
    p_cc_last_4 NUMBER,
    p_msg       OUT VARCHAR2
) AS
    l_loan_amt         NUMBER;
    l_count            NUMBER;
    l_loan_eligibility CHAR(1);
    no_record_exception EXCEPTION;
BEGIN
    SELECT
        COUNT(*)
    INTO l_count
    FROM
        credit_card_loan
    WHERE
            phone = p_phone
        AND substr(credit_card_number, - 4) = p_cc_last_4;

    IF l_count = 0 THEN
        RAISE no_record_exception;
    END IF;
    SELECT
        loan_amount
    INTO l_loan_amt
    FROM
        credit_card_loan
    WHERE
            phone = p_phone
        AND substr(credit_card_number, - 4) = p_cc_last_4
        AND loan_eligibility = 'Y';

    p_msg := 'Approved Loan amount is:' || to_char(l_loan_amt, '9,99,999');
EXCEPTION
    WHEN no_record_exception THEN
        p_msg := 'Entered details are incorrect.please check';
    WHEN no_data_found THEN
        p_msg := 'sorry,no offers available.please try after sometime';
END eligibility_for_loan;
/



--executing the procedure
--It shows the approved loan amount
DECLARE
    res VARCHAR2(100);
BEGIN
    eligibility_for_loan(p_phone => 9392327587, p_cc_last_4 => 6666, p_msg => res);
    dbms_output.put_line(res);
END;
/



--It shows the loan unavailable meassage
DECLARE
    res VARCHAR2(100);
BEGIN
    eligibility_for_loan(p_phone => 9392327587, p_cc_last_4 => 7777, p_msg => res);
    dbms_output.put_line(res);
END;
/


--It shows the entered details incorrect
DECLARE
    res VARCHAR2(100);
BEGIN
    eligibility_for_loan(p_phone => 9392327587, p_cc_last_4 => 1111, p_msg => res);
    dbms_output.put_line(res);
END;
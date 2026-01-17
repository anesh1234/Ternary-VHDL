class TernLogops:
    """
    Class to hold logical operator's truth tables, 
    and to fetch these for evaluatiuon
    """
    def __init__(self, a):
        # 1-arity logops
        self._COL = ['X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X']
        self._NTI = ['X', 'X', '+', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X']
        self._STI = ['X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X']
        self._MTI = ['X', 'X', '-', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X']
        self._INC = ['X', 'X', '0', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X']
        self._PIT = ['X', 'X', '+', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X']
        self._DEC = ['X', 'X', '+', '-', '0', 'X', 'X', 'X', 'X', 'X', 'X']
        self._CLD = ['X', 'X', '-', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X']
        self._COM = ['X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X']
        self._IPT = ['X', 'X', '-', '-', '+', 'X', 'X', 'X', 'X', 'X', 'X']
        self._IMT = ['X', 'X', '+', '-', '+', 'X', 'X', 'X', 'X', 'X', 'X']
        self._BUF = ['X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X']
        self._CLU = ['X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X']
        self._INT = ['X', 'X', '-', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X']
        self._COH = ['X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X']
        # 2-arity logops
        self._SUM = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '-', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '+', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._CON = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._NCO = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._MINI = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._MAX = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._NMI = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._NMA = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'] 
        self._XOR = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._MUL = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._IMP = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._ANY = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '-', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._NAN = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '+', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._MLE = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '+', '+', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X'] 
        self._ENA = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '0', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '0', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
        self._DES = ['X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',  
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '-', '-', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '0', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', '-', '+', '+', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X',
            'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X', 'X']
                
    def eval(self, ttable: list[str], left: list[str], right: list[str] = None) -> list[str]:
        """
        Evaluate vectors using the truth table for the given operator.
        - name: operator name (e.g., 'COL', 'NTI', 'SUM', 'CON')
        - left: list of strings (each string is a vector of trits)
        - right: optional list of strings (same length as left for binary operators)
        Returns: list of result strings.
        """
        SYMBOLS = ('U', 'X', '-', '0', '+', 'Z', 'W', 'B', 'L', 'H', 'D')
        lut = {sym: ttable[i] for i, sym in enumerate(SYMBOLS)}

            results = []
            for trit in left:
                if trit not in SYMBOLS:
                    raise ValueError(f"Invalid trit '{trit}' in vector '{vec}'")
                out.append(lut[trit])
                results.append("".join(out))
            return results

        else:
            # Binary operator
            if len(left) != len(right):
                raise ValueError("Left and right lists must have the same length")
            table = self.get_logops_table(name, left, right)
            if len(table) != N * N:
                raise ValueError(f"Binary table must have {N*N} entries")
            lut = {}
            for i, a in enumerate(SYMBOLS):
                for j, b in enumerate(SYMBOLS):
                    lut[(a, b)] = table[i * N + j]

            results = []
            for a_vec, b_vec in zip(left, right):
                if len(a_vec) != len(b_vec):
                    raise ValueError(f"Vector length mismatch: '{a_vec}' vs '{b_vec}'")
                out = []
                for a, b in zip(a_vec, b_vec):
                    if a not in SYMBOLS or b not in SYMBOLS:
                        raise ValueError(f"Invalid trits '{a}', '{b}' in pair")
                    out.append(lut[(a, b)])
                results.append("".join(out))
            return results





    # def get_logops_table(self, name:str, left:list[str], right:list[str] = None):
    #     if right == None:
    #         match name:
    #             case "COL":
    #                 return self._COL
    #             case "NTI":
    #                 return self._NTI
    #             case "STI":
    #                 return self._STI
    #             case "MTI":
    #                 return self._MTI
    #             case "INC":
    #                 return self._INC
    #             case "PIT":
    #                 return self._PIT
    #             case "DEC":
    #                 return self._DEC
    #             case "CLD":
    #                 return self._CLD
    #             case "COM":
    #                 return self._COM
    #             case "IPT":
    #                 return self._IPT
    #             case "IMT":
    #                 return self._IMT
    #             case "BUF":
    #                 return self._BUF
    #             case "CLU":
    #                 return self._CLU
    #             case "INT":
    #                 return self._INT
    #             case "COH":
    #                 return self._COH
    #             case _:
    #                 raise ValueError(f"No 1-arity function for {name} was found.")
    #     else:
    #         match name:
    #             case "SUM":
    #                 return self._SUM
    #             case "CON":
    #                 return self._CON
    #             case "NCO":
    #                 return self._NCO
    #             case "MINI":
    #                 return self._MINI
    #             case "MAX":
    #                 return self._MAX
    #             case "NMI":
    #                 return self._NMI
    #             case "NMA":
    #                 return self._NMA
    #             case "XOR":
    #                 return self._XOR
    #             case "XOR":
    #                 return self._XOR
    #             case "IMP":
    #                 return self._IMP
    #             case "ANY":
    #                 return self._ANY
    #             case "NAN":
    #                 return self._NAN
    #             case "MLE":
    #                 return self._MLE
    #             case "ENA":
    #                 return self._ENA
    #             case "DES":
    #                 return self._DES
    #             case _:                     
    #                 raise ValueError(f"No 2-arity function for {name} was found.")
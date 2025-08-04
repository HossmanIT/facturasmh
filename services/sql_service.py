from datetime import datetime, date, timedelta
from typing import List
from sqlalchemy.orm import Session
from models.entities import SQLFACTF03
import logging

logger = logging.getLogger(__name__)

class SQLService:
    def __init__(self, db: Session):
        self.db = db

    def get_recent_invoices(self, days_back: int = 180) -> List[SQLFACTF03]:
        """Obtiene las facturas de los últimos N días que no han sido sincronizadas"""
        end_date = datetime.now()
        start_date = end_date - timedelta(days=days_back)
        
        try:
            invoices = self.db.query(SQLFACTF03).filter(
                SQLFACTF03.FECHA_DOC >= start_date,
                SQLFACTF03.FECHA_DOC <= end_date,
                SQLFACTF03.SINCRONIZADO == False
            ).all()

            logger.info(f"Encontradas {len(invoices)} facturas no sincronizadas de los últimos {days_back} días")
            return invoices
        except Exception as e:
            logger.error(f"Error al obtener facturas: {str(e)}")
            raise
--Hetredo Warden
function c26043003.initial_effect(c)
	--summon with opponent materials
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(c26043003.otfilter))
	e1:SetValue(POS_FACEUP)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26043003,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)	
	e2:SetLabel(0)
	e2:SetCondition(c26043003.condition)
	e2:SetTarget(c26043003.target)
	e2:SetOperation(c26043003.operation)
	c:RegisterEffect(e2)
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c26043003.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--cannot be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetLabel(26043003)
	e4:SetValue(c26043003.sumcode)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e7)
end
function c26043003.sumcode(e,c)
	local code=e:GetLabel()
	if not c then return false end
	return not c:ListsCodeAsMaterial(code)
end
function c26043003.otfilter(c)
	local mg=c:GetMaterial()
	return c:IsFaceup() and c:GetType()&TYPE_FUSION+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK ~=0
	and not (mg and c:GetSummonType()&SUMMON_TYPE_FUSION+SUMMON_TYPE_XYZ+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_LINK~=0 and mg:IsExists(c26043003.code,1,nil,c))
end
function c26043003.code(c,mc)
	return mc:ListsCodeAsMaterial(c:GetCode())
end
function c26043003.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	if #g~=2 then return false end
	if g:FilterCount(Card.IsType,nil,TYPE_FUSION)>1 then
		typ=(TYPE_FUSION)
	elseif g:FilterCount(Card.IsType,nil,TYPE_SYNCHRO)>1 then
		typ=(TYPE_SYNCHRO)
	elseif g:FilterCount(Card.IsType,nil,TYPE_XYZ)>1 then
		typ=(TYPE_XYZ)
	elseif g:FilterCount(Card.IsType,nil,TYPE_LINK)>1 then
		typ=(TYPE_LINK)
	end
	e:GetLabelObject():SetLabel(typ)
end
function c26043003.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function c26043003.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TRIBUTE) and e:GetLabel()~=0
end
function c26043003.bfilter(c,tp,typ)
	return c:IsType(typ) and c:IsAbleToRemove(tp)
end
function c26043003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove(tp) end
	local typ=e:GetLabel()
	local g=Duel.GetMatchingGroup(c26043003.bfilter,tp,0,LOCATION_GRAVE,nil,tp,typ)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,1)
end
function c26043003.operation(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local g=Duel.GetMatchingGroup(c26043003.bfilter,tp,0,LOCATION_GRAVE,nil,tp,typ)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
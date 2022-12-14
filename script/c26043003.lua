--Hetredo Wyvern
function c26043003.initial_effect(c)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(c26043003.otfilter))
	e1:SetValue(POS_FACEUP)
	c:RegisterEffect(e1)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetLabel(26043003)
	e3:SetValue(c26043003.sumcode)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e5)
end
function c26043003.sumcode(e,c)
	local code=e:GetLabel()
	if not c then return false end
	return not c:ListsCodeAsMaterial(code)
end
function c26043003.otfilter(c)
	local mg=c:GetMaterial()
	return c:IsFaceup() and c:GetSummonType()&SUMMON_TYPE_FUSION+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK ~=0
	and mg and not mg:IsExists(c26043003.code,1,nil,c)
end
function c26043003.code(c,mc)
	return mc:ListsCodeAsMaterial(c:GetCode()) or mc:ListsCode(c:GetCode())
end
